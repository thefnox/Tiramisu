CAKE.Voices = { } -- I hear voices D:>
CAKE.VoiceGroups = {}

function CAKE.CanVoice( ply, soundgroup )
	if !CAKE.ConVars[ "AllowVoices" ] then return false end
	if !soundgroup then return false end
	if !CAKE.VoiceGroups[soundgroup] then return false end
	if CAKE.VoiceGroups[soundgroup] then
		if !CAKE.VoiceGroups[soundgroup].CanVoice then
			return true 
		else
			return CAKE.VoiceGroups[soundgroup].CanVoice(ply)
		end
	end
end

function CAKE.AddVoiceGroup( soundgroup, callback ) --The callback is there so you can test whether someone can use a voicegroup or not.
	CAKE.VoiceGroups[soundgroup] = {}
	CAKE.VoiceGroups[soundgroup].CanVoice = callback
	if !CAKE.VoiceGroups[soundgroup].CanVoice then
		CAKE.VoiceGroups[soundgroup].CanVoice = function() return true end
	end
end

function CAKE.AddVoice( id, path, soundgroup, name, fa, category)
	CAKE.Voices[id] = {}
	CAKE.Voices[id].MalePath = path
	CAKE.Voices[id].FemalePath = fa or path
	CAKE.Voices[id].Name = name
	CAKE.Voices[id].Group = soundgroup
	CAKE.Voices[id].Category = category or "Unspecified"
end

-- Human Voices
CAKE.AddVoiceGroup( "Citizen" )

--Taunts
CAKE.AddVoice("fantastic", "vo/npc/male01/fantastic01.wav", "Citizen", "Fantastic!", "vo/npc/female01/fantastic.wav", "Cries")
CAKE.AddVoice("doingsomething", "vo/npc/male01/doingsomething.wav", "Citizen", "Shouldn't we..", "vo/npc/female01/doingsomething.wav", "Cries")
CAKE.AddVoice("gotone2", "vo/npc/male01/gotone02.wav", "Citizen", "Hahah! I got one!", "vo/npc/female01/.wav", "Cries")
CAKE.AddVoice("heregoesnothing", "vo/npc/male01/squad_affirm06.wav", "Citizen", "Here goes nothing.", "vo/npc/female01/squad_affirm06.wav", "Cries")
CAKE.AddVoice("yougotit", "vo/npc/male01/yougotit02.wav", "Citizen", "You got it!", "vo/npc/female01/yougotit.wav", "Cries")
CAKE.AddVoice("finally", "vo/npc/male01/finally.wav", "Citizen", "Finally.", "vo/npc/female01/finally.wav", "Cries")
CAKE.AddVoice("donicely", "vo/npc/male01/thislldonicely01.wav", "Citizen", "This'll do nicely!", "vo/npc/female01/thislldonicely01.wav", "Cries")
CAKE.AddVoice("waitingsomebody", "vo/npc/male01/waitingsomebody.wav", "Citizen", "You waiting for somebody?", "vo/npc/female01/waitingsomebody.wav", "Cries")
CAKE.AddVoice("gotone1", "vo/npc/male01/gotone01.wav", "Citizen", "Got one!", "vo/npc/female01/gotone01.wav", "Cries")

--Cries
CAKE.AddVoice("combine", "vo/npc/male01/combine01.wav", "Citizen", "Combine!", "vo/npc/female01/combine01.wav", "Cries")
CAKE.AddVoice("gethellout", "vo/npc/male01/gethellout.wav", "Citizen", "Get the hell out of here!", "vo/npc/female01/gethellout.wav", "Cries")
CAKE.AddVoice("goodgod", "vo/npc/male01/goodgod.wav", "Citizen", "Good god!", "vo/npc/female01/goodgod.wav", "Cries")
CAKE.AddVoice("noscream1", "vo/npc/male01/no01.wav", "Citizen", "No! NO!", "vo/npc/female01/no01.wav", "Cries")
CAKE.AddVoice("noscream2", "vo/npc/male01/no02.wav", "Citizen", "Noooooo!", "vo/npc/female01/no02.wav", "Cries")
CAKE.AddVoice("runforyourlife", "vo/npc/male01/runforyourlife01.wav", "Citizen", "Run for your life!", "vo/npc/female01/runforyourlife.wav", "Cries")
CAKE.AddVoice("run", "vo/npc/male01/strider_run.wav", "Citizen", "Ruuuuun!", "vo/npc/female01/strider_run.wav", "Cries")
CAKE.AddVoice("help", "vo/npc/male01/help01.wav", "Citizen", "HELP!", "vo/npc/female01/help01.wav", "Cries")

--Chatter
CAKE.AddVoice("excuseme", "vo/npc/male01/excuseme01.wav", "Citizen", "Excuse me.", "vo/npc/female01/excuseme01.wav", "Chatter")
CAKE.AddVoice("hi", "vo/npc/male01/hi01.wav", "Citizen", "Hi.", "vo/npc/female01/hi01.wav", "Chatter")
CAKE.AddVoice("illstayhere", "vo/npc/male01/illstayhere01.wav", "Citizen", "I'll stay here.", "vo/npc/female01/illstayhere01.wav", "Chatter")
CAKE.AddVoice("letsgo", "vo/npc/male01/letsgo01.wav", "Citizen", "Let's go!", "vo/npc/female01/letsgo01.wav", "Chatter")
CAKE.AddVoice("imready", "vo/npc/male01/okimready01.wav", "Citizen", "Ok, I'm ready.", "vo/npc/female01/okimready01.wav", "Chatter")
CAKE.AddVoice("overhere", "vo/npc/male01/overhere01.wav", "Citizen", "Hey, over here!", "vo/npc/female01/overhere01.wav", "Chatter")
CAKE.AddVoice("sorry", "vo/npc/male01/sorry01.wav", "Citizen", "Sorry.", "vo/npc/female01/sorry01.wav", "Chatter")
CAKE.AddVoice("whoops", "vo/npc/male01/whoops01.wav", "Citizen", "Whoops.", "vo/npc/female01/whoops01.wav", "Chatter")
CAKE.AddVoice("yeah", "vo/npc/male01/yeah02.wav", "Citizen", "Yeah!", "vo/npc/female01/yeah02.wav", "Chatter")


-- Combine
CAKE.AddVoiceGroup( "Combine" )

--Orders
CAKE.AddVoice("administer", "npc/metropolice/vo/administer.wav", "Combine", "Administer.", false, "Orders")
CAKE.AddVoice("apply", "npc/metropolice/vo/apply.wav", "Combine", "Apply.", false, "Orders")
CAKE.AddVoice("movein", "npc/metropolice/vo/allunitsmovein.wav", "Combine", "All units, move in.", false, "Orders")
CAKE.AddVoice("amputate", "npc/metropolice/vo/amputate.wav", "Combine", "Amputate.", false, "Orders")
CAKE.AddVoice("cauterize", "npc/metropolice/vo/cauterize.wav", "Combine", "Cauterize.", false, "Orders")
CAKE.AddVoice("miscount", "npc/metropolice/vo/checkformiscount.wav", "Combine", "Check for miscount.", false, "Orders")
CAKE.AddVoice("destroythatcover", "npc/metropolice/vo/destroythatcover.wav", "Combine", "Destroy that cover!", false, "Orders")
CAKE.AddVoice("document", "npc/metropolice/vo/document.wav", "Combine", "Document.", false, "Orders")
CAKE.AddVoice("investigate", "npc/metropolice/vo/investigate.wav", "Combine", "Investigate.", false, "Orders")
CAKE.AddVoice("prosecute", "npc/metropolice/vo/prosecute.wav", "Combine", "Prosecute.", false, "Orders")
CAKE.AddVoice("isolate", "npc/metropolice/vo/isolate.wav", "Combine", "Isolate.", false, "Orders")

--Taunts
CAKE.AddVoice("verdictadministered", "npc/metropolice/vo/finalverdictadministered.wav", "Combine", "Final verdict administered.", false, "Taunts")
CAKE.AddVoice("finalwarning", "npc/metropolice/vo/finalwarning.wav", "Combine", "Final warning.", false, "Taunts")
CAKE.AddVoice("firstwarningmove", "npc/metropolice/vo/firstwarningmove.wav", "Combine", "First warning. Move away.", false, "Taunts")
CAKE.AddVoice("getoutofhere", "npc/metropolice/vo/getoutofhere.wav", "Combine", "Get out of here.", false, "Taunts")
CAKE.AddVoice("nowgetoutofhere", "npc/metropolice/vo/nowgetoutofhere.wav", "Combine", "Now get out of here.", false, "Taunts")
CAKE.AddVoice("vacatecitizen", "npc/metropolice/vo/vacatecitizen.wav", "Combine", "Vacate, citizen.", false, "Taunts")
CAKE.AddVoice("malcompliance", "npc/metropolice/vo/youwantamalcomplianceverdict.wav", "Combine", "Malcompliance verdict", false, "Taunts")
CAKE.AddVoice("control100percent", "npc/metropolice/vo/control100percent.wav", "Combine", "Control is 100 %", false, "Taunts")
CAKE.AddVoice("movealong", "npc/metropolice/vo/isaidmovealong.wav", "Combine", "I said move along.", false, "Taunts")
CAKE.AddVoice("keepmoving", "npc/metropolice/vo/keepmoving.wav", "Combine", "Keep moving.", false, "Taunts")

--Cries
CAKE.AddVoice("1199", "npc/metropolice/vo/11-99officerneedsassistance.wav", "Combine", "11-99, officer needs assistance!", false, "Cries")
CAKE.AddVoice("holdit", "npc/metropolice/vo/holdit.wav", "Combine", "Hold it!", false, "Cries")
CAKE.AddVoice("dontmove", "npc/metropolice/vo/dontmove.wav", "Combine", "Don't move!", false, "Cries")
CAKE.AddVoice("getdown", "npc/metropolice/vo/getdown.wav", "Combine", "Get down!", false, "Cries")
CAKE.AddVoice("grenade", "npc/metropolice/vo/grenade.wav", "Combine", "Grenade!", false, "Cries")
CAKE.AddVoice("help", "npc/metropolice/vo/help.wav", "Combine", "Help!", false, "Cries")
CAKE.AddVoice("coverme", "npc/metropolice/vo/covermegoingin.wav", "Combine", "Cover me, I'm going in!", false, "Cries")
CAKE.AddVoice("hesrunning", "npc/metropolice/vo/hesrunning.wav", "Combine", "He's running!", false, "Cries")
CAKE.AddVoice("officerneedshelp", "npc/metropolice/vo/officerneedshelp.wav", "Combine", "Officer needs help!", false, "Cries")
CAKE.AddVoice("thereheis", "npc/metropolice/vo/thereheis.wav", "Combine", "There he is!", false, "Cries")
CAKE.AddVoice("shit", "npc/metropolice/vo/shit.wav", "Combine", "Shit!", false, "Cries")

--Chatter
CAKE.AddVoice("youcango", "npc/metropolice/vo/allrightyoucango.wav", "Combine", "All right. You can go.", false, "Chatter")
CAKE.AddVoice("anticitizen", "npc/metropolice/vo/anticitizen.wav", "Combine", "Anticitizen.", false, "Chatter")
CAKE.AddVoice("chuckle", "npc/metropolice/vo/chuckle.wav", "Combine", "Chuckle", false, "Chatter")
CAKE.AddVoice("citizen", "npc/metropolice/vo/citizen.wav", "Combine", "Citizen.", false, "Chatter")
CAKE.AddVoice("converging", "npc/metropolice/vo/converging.wav", "Combine", "Converging.", false, "Chatter")
CAKE.AddVoice("copy", "npc/metropolice/vo/copy.wav", "Combine", "Copy.", false, "Chatter")
CAKE.AddVoice("trespass", "npc/metropolice/vo/criminaltrespass63.wav", "Combine", "6-3 Criminal Trespass.", false, "Chatter")
CAKE.AddVoice("introuble", "npc/metropolice/vo/dispatchineed10-78.wav", "Combine", "Dispatch, I need 10-78", false, "Chatter")
CAKE.AddVoice("investigating", "npc/metropolice/vo/investigating10-103.wav", "Combine", "Investigating 10-103.", false, "Chatter")
CAKE.AddVoice("location", "npc/metropolice/vo/location.wav", "Combine", "Location.", false, "Chatter")
CAKE.AddVoice("responding", "npc/metropolice/vo/responding.wav", "Combine", "Responding.", false, "Chatter")
CAKE.AddVoice("rodgerthat", "npc/metropolice/vo/rodgerthat.wav", "Combine", "Roger that.", false, "Chatter")
CAKE.AddVoice("searchingforsuspect", "npc/metropolice/vo/searchingforsuspect.wav", "Combine", "Searching for suspect.", false, "Chatter")
CAKE.AddVoice("sweepingforsuspect", "npc/metropolice/vo/sweepingforsuspect.wav", "Combine", "Sweeping for suspect.", false, "Chatter")
CAKE.AddVoice("unlawfulentry", "npc/metropolice/vo/unlawfulentry603.wav", "Combine", "603, unlawful entry.", false, "Chatter")


-- Vortigaunt
CAKE.AddVoiceGroup( "Vortigaunt" )

--Proverbs
CAKE.AddVoice("hopeless", "vo/npc/vortigaunt/hopeless.wav", "Vortigaunt", "Our cause seems hopeless.", false, "Proverbs")
CAKE.AddVoice("livetoserve", "vo/npc/vortigaunt/livetoserve.wav", "Vortigaunt", "We live to serve.", false, "Proverbs")
CAKE.AddVoice("persevere", "vo/npc/vortigaunt/persevere.wav", "Vortigaunt", "This is more than anyone can bear. But we will persevere.", false, "Proverbs")
CAKE.AddVoice("poet", "vo/npc/vortigaunt/poet.wav", "Vortigaunt", "Our finest poet describes it thus. Galum bala gilamar!", false, "Proverbs")
CAKE.AddVoice("prevail", "vo/npc/vortigaunt/prevail.wav", "Vortigaunt", "We shall prevail.", false, "Proverbs")
CAKE.AddVoice("whereto", "vo/npc/vortigaunt/whereto.wav", "Vortigaunt", "Where to now, and to what end?", false, "Proverbs")

--Taunts
CAKE.AddVoice("accompany", "vo/npc/vortigaunt/accompany.wav", "Vortigaunt", "Gladly we accompany.", false, "Taunts")
CAKE.AddVoice("allowme", "vo/npc/vortigaunt/allowme.wav", "Vortigaunt", "Allow me.", false, "Taunts")
CAKE.AddVoice("asyouwish", "vo/npc/vortigaunt/asyouwish.wav", "Vortigaunt", "As you wish.", false, "Taunts")
CAKE.AddVoice("beofservice", "vo/npc/vortigaunt/beofservice.wav", "Vortigaunt", "Can we be of service?", false, "Taunts")
CAKE.AddVoice("calm", "vo/npc/vortigaunt/calm.wav", "Vortigaunt", "Calm yourself.", false, "Taunts")
CAKE.AddVoice("canconvice", "vo/npc/vortigaunt/canconvice.wav", "Vortigaunt", "Can we not convince you otherwise?", false, "Taunts")
CAKE.AddVoice("forfreedom", "vo/npc/vortigaunt/forfreedom.wav", "Vortigaunt", "For freedom!", false, "Taunts")

--Chatter
CAKE.AddVoice("forward", "vo/npc/vortigaunt/forward.wav", "Vortigaunt", "Forward.", false, "Taunts")
CAKE.AddVoice("halt", "vo/npc/vortigaunt/halt.wav", "Vortigaunt", "Halt.", false, "Taunts")
CAKE.AddVoice("caution", "vo/npc/vortigaunt/caution.wav", "Vortigaunt", "Caution!", false, "Taunts")
CAKE.AddVoice("certainly", "vo/npc/vortigaunt/certainly.wav", "Vortigaunt", "Certainly.", false, "Taunts")
CAKE.AddVoice("done", "vo/npc/vortigaunt/done.wav", "Vortigaunt", "Done.", false, "Taunts")
CAKE.AddVoice("yes", "vo/npc/vortigaunt/yes.wav", "Vortigaunt", "Yes!", false, "Taunts")