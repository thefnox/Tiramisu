_R.Container = {}
local meta = FindMetaTable("Container")
meta.Items = {}
meta.Height = 0
meta.Width = 0

function meta:New()
	local new = {}
	setmetatable( new, self )
	self.__index = self
	new.Items = {}
	new.Height = 0
	new.Width = 0
	return new
end

function meta:SetSize( w, h )
	for i=1, h do
		if !self.Items[i] then
			self.Items[i] = {}
		end
		for j=1, w do
			if !self.Items[i][j] then
				self.Items[i][j] = {}
			end
		end
	end
	self.Width = w
	self.Height = h
end

function meta:Clear()
	for i=1, self.Height do
		if !self.Items[i] then
			self.Items[i] = {}
		end
		for j=1, self.Width do
			if !self.Items[i][j] then
				self.Items[i][j] = {}
			end
		end
	end
end

function meta:SetInfinite( bool )
	self.Infinite = bool
end

function meta:GetInfinite()
	return self.Infinite
end

function meta:SetNonRecursive(bool)
	self.NonRecursive = bool
end

function meta:GetNonRecursive()
	return meta:GetInfinite() or self.NonRecursive
end

function meta:IsSlotEmpty( x, y )
	if x <= self.Width and y <= self.Height then
		if self.Items[y] and self.Items[y][x] and table.Count(self.Items[y][x]) > 0 then
			return false
		end
	end
	return true
end

function meta:ClearSlot( x, y )
	if x <= self.Width and y <= self.Height then
		self.Items[y][x] = {}
		if SERVER then
			umsg.Start("c_ClearS", CAKE.GetPlyTrackingContainer( self.UniqueID ))
				umsg.String(self.UniqueID)
				umsg.Short(x)
				umsg.Short(y)
			umsg.End()
			self:Save()
		end
	end
end

function meta:FillSlot( x, y, class, itemid )
	if x <= self.Width and y <= self.Height then
		self.Items[y][x] = {
			["class"] = class,
			["itemid"] = itemid
		}
		if SERVER then
			umsg.Start("c_AddTo", CAKE.GetPlyTrackingContainer( self.UniqueID ))
				umsg.String(self.UniqueID)
				umsg.String(itemid)
				umsg.String(class)
				umsg.Short(x)
				umsg.Short(y)
			umsg.End()
			self:Save()
		end
	end
end

function meta:SwapSlots( x1, y1, x2, y2 )
	if !self:IsSlotEmpty( x1, y1 ) then
		if self:IsSlotEmpty( x2, y2 ) then
			local class, itemid = self.Items[y1][x1].class, self.Items[y1][x1].itemid
			self:ClearSlot(x1, y1)
			self:FillSlot(x2, y2, class, itemid)
		else
			local class, itemid = self.Items[y2][x2].class, self.Items[y2][x2].itemid
			self:FillSlot(x2, y2, self.Items[y1][x1].class, self.Items[y1][x1].itemid)
			self:FillSlot(x1, y1, class, itemid)
		end
	end
end

function meta:HasItem( class )
	for i=1, self.Height do
		for j=1, self.Width do
			if !self:IsSlotEmpty(j,i) and self.Items[i][j].class == class then 
				return true
			end
		end
	end
	return false
end

function meta:HasItemID( itemid )
	for i=1, self.Height do
		for j=1, self.Width do
			if !self:IsSlotEmpty(j,i) and self.Items[i][j].itemid == itemid then 
				return self.Items[i][j].class
			end
		end
	end
	return false
end

function meta:TakeItemID( id )
	for i=1, self.Height do
		for j=1, self.Width do
			if !self:IsSlotEmpty(j,i) and self.Items[i][j].itemid == id then
				local class = self.Items[i][j].class
				if SERVER then
					umsg.Start("c_Take", CAKE.GetPlyTrackingContainer( self.UniqueID ))
						umsg.String(self.UniqueID)
						umsg.String(id)
					umsg.End()
					self:Save()
				end
				self:ClearSlot( j, i )
				return class
			end
		end
	end
end

if SERVER then
	function meta:Save()
		if self.UniqueID then
			file.Write(CAKE.Name .. "/containers/" .. CAKE.ConVars[ "Schema" ] .. "/" .. self.UniqueID.. ".txt", glon.encode(self))
		end
	end

	function meta:GetItemCount()
		local count = 0
		for i=1, self.Height do
			for j=1, self.Width do
				if !self:IsSlotEmpty(j,i) then 
					count = count + 1
					if !self:GetNonRecursive() then
						if self.Items[i][j] and self.Items[i][j].itemid and CAKE.GetUData(self.Items[i][j].itemid, "container") then
							if CAKE.IsContainer(CAKE.GetUData(self.Items[i][j].itemid, "container")) then
								count = count + CAKE.GetContainer(CAKE.GetUData(self.Items[i][j].itemid, "container")):GetItemCount()
							end
						end
					end
				end
			end
		end
		return count
	end

	function meta:IsFull()
		if self:GetInfinite() then
			return false
		end 

		if self:GetItemCount() >= self.Width * self.Height then
			return true
		end
		return false
	end

	function meta:AddItem( class, id )
		if self:GetInfinite() and self:GetItemCount() >= self.Width * self.Height then
			self.Height = self.Height + 1
			self.Items[self.Height] = {}
			for i=1, self.Width do
				self.Items[self.Height][i] = {}
			end
			umsg.Start("c_Expand", CAKE.GetPlyTrackingContainer( self.UniqueID ))
				umsg.String(self.UniqueID)
				umsg.Short(self.Height)
			umsg.End()
		end

		if !self:IsFull() then
			for i=1, self.Height do
				for j=1, self.Width do
					if self:IsSlotEmpty(j,i) then 
						self:FillSlot( j, i, class, id )
						return
					end
				end
			end
		end
	end

	function CAKE.CreateContainerID()
		local repnum = 0
		local uidfile = file.Exists( CAKE.Name .. "/containers/" .. CAKE.ConVars[ "Schema" ] .. "/" .. os.time() .. repnum .. ".txt" )
		while uidfile do
			repnum = repnum + 1
			uidfile = file.Exists( CAKE.Name .. "/containers/" .. CAKE.ConVars[ "Schema" ] .. "/" .. os.time() .. repnum .. ".txt" )
		end
		return os.time() .. repnum
	end

	function CAKE.CreateContainerObject( filename )
		local container = FindMetaTable("Container"):New()

		if filename and file.Exists( filename ) then
			local tbl = glon.decode( file.Read(filename) )
			container.UniqueID = tbl.UniqueID
			container:Save()
		else
			container.UniqueID = CAKE.CreateContainerID()
			container:Save()
		end
		return container
	end
else
	function CAKE.CreateContainerObject( uid )
		local container = FindMetaTable("Container"):New()
		container.UniqueID = uid
		return container
	end
end