CLPLUGIN.Name = "Charcreation Menu"
CLPLUGIN.Author = "FNox/Ryaga"
--Yep, 1000 lines of character creation, clientside. Beat that, Tacoscript 2

local function ErrorMessage( msg )
	Derma_Message(msg, "Error!", "OK")
end

local Race = {}
Race[ "Human" ] = {}
Race[ "Human" ][ "desc" ] = [[You are probably one of these. 

Humans are the most flexible race to play. They can become essentially anything that is within boundaries.

Humans use sophisticated and flexible tactics against their opponents. However, most humans are commoners, and not warriors. They can speak any languages if it is within their boundaries (i.e. having the correct vocal parts to speak it) and can use essentially any technology. They are not the most intelligent race, but they can be very intelligent depending on history and training.]]
Race[ "Human" ][ "models" ] = {}
Race[ "Human" ][ "models" ][ "female" ] = {
			        "models/Humans/Group01/Female_01.mdl",
              "models/Humans/Group01/Female_02.mdl",
              "models/Humans/Group01/Female_03.mdl",
              "models/Humans/Group01/Female_04.mdl",
              "models/Humans/Group01/Female_06.mdl",
              "models/Humans/Group01/Female_07.mdl",
              "models/Humans/Group02/Female_01.mdl",
              "models/Humans/Group02/Female_02.mdl",
              "models/Humans/Group02/Female_03.mdl",
              "models/Humans/Group02/Female_04.mdl",
              "models/Humans/Group02/Female_06.mdl",
              "models/Humans/Group02/Female_07.mdl"
	      }
Race[ "Human" ][ "models" ][ "male" ] = {
		            "models/humans/group01/male_01.mdl",
              "models/humans/group01/male_02.mdl",
              "models/humans/group01/male_03.mdl",
              "models/humans/group01/male_04.mdl",
			  "models/humans/group01/male_05.mdl",
              "models/humans/group01/male_06.mdl",
              "models/humans/group01/male_07.mdl",
              "models/humans/group01/male_08.mdl",
              "models/humans/group01/male_09.mdl",
              "models/humans/group02/male_01.mdl",
              "models/humans/group02/male_02.mdl",
              "models/humans/group02/male_03.mdl",
              "models/humans/group02/male_04.mdl",
			   "models/humans/group02/male_05.mdl",
              "models/humans/group02/male_06.mdl",
              "models/humans/group02/male_07.mdl",
              "models/humans/group02/male_08.mdl",
              "models/humans/group02/male_09.mdl"
			  
	      }
		
Race[ "Tiefling" ] = {}
Race[ "Tiefling" ][ "desc" ] = [[Tieflings are at first glance, human in appearance. Upon closer inspection, one might expect to find a pair of small or often concealed horns similiar to those of a goat, a tail and perhaps even wings. Every Tiefling has their horns, along with a compulsory set of sharpened canines and red tinted eyes. Their skin is most often tanned bronze in hue, and they stand slightly shorter than a human. Tiefling hair comes in three main types, those being brown colours, reddish colours and black colours. Mixes of such types are not uncommon. They tend to be agile. Tieflings are adept at seeing and moving in the dark.

They have some amount of fiendish blood somewhere in their ancestry, but should not be mistaken for half-fiends. A Tiefling's fiendish heritage is much more dilute, never more than 1/8th of their blood and most often the fiendish influence is even farther in their past than that. Nearly all Tieflings are of human ancestry.

Tieflings have no lands to call their own. They make people feel uncomfortable and are generally shunned. They roam the lands selling their mercenary or roguish services to the highest bidder. Some travel to escape the taint that their heritage has put on them. Tieflings are distrusted by nearly all.
 ]]
Race[ "Tiefling" ][ "models" ] = {}
Race[ "Tiefling" ][ "models" ][ "male" ] = {
		            "models/humans/group01/male_01.mdl",
              "models/humans/group01/male_02.mdl",
              "models/humans/group01/male_03.mdl",
              "models/humans/group01/male_04.mdl",
			  "models/humans/group01/male_05.mdl",
              "models/humans/group01/male_06.mdl",
              "models/humans/group01/male_07.mdl",
              "models/humans/group01/male_08.mdl",
              "models/humans/group01/male_09.mdl",
              "models/humans/group02/male_01.mdl",
              "models/humans/group02/male_02.mdl",
              "models/humans/group02/male_03.mdl",
              "models/humans/group02/male_04.mdl",
			   "models/humans/group02/male_05.mdl",
              "models/humans/group02/male_06.mdl",
              "models/humans/group02/male_07.mdl",
              "models/humans/group02/male_08.mdl",
              "models/humans/group02/male_09.mdl"
	      }
Race[ "Tiefling" ][ "models" ][ "female" ] = {
			  "models/Humans/Group01/Female_01.mdl",
              "models/Humans/Group01/Female_02.mdl",
              "models/Humans/Group01/Female_03.mdl",
              "models/Humans/Group01/Female_04.mdl",
              "models/Humans/Group01/Female_06.mdl",
              "models/Humans/Group01/Female_07.mdl",
              "models/Humans/Group02/Female_01.mdl",
              "models/Humans/Group02/Female_02.mdl",
              "models/Humans/Group02/Female_03.mdl",
              "models/Humans/Group02/Female_04.mdl",
              "models/Humans/Group02/Female_06.mdl",
              "models/Humans/Group02/Female_07.mdl"
	      }
		  
Race[ "Dragonborn" ] = {}
Race[ "Dragonborn" ][ "desc" ] = [[The Dragonborn are humanoid creatures that mimic the form of the most ancient beings of the mortal realm, the Dragons. All Dragonborn have very rough, scaly skin that can can vary from red to green, and have an average height of around 5'10, though a Dragonborn can be as tall as six feet or as short as five. Dragonborn have wings that can fold closely into their back, allowing for armor and human or elven style clothing. Just as their larger counterparts, they have several rows of razor sharp teeth and potentially deadly claws, though many Dragonborn maintain these claws for daily ease and use, removing the possibility of harming the softer skinned species by accident. As a result of a minor rift in their culture, two somewhat distinct ‘types’ of Dragonborn have formed, though they remain the same race. Those that remain true to the ways of their ancestors are part of the warrior class, and focus on commanding the considerable strength within their bodies, being built and stout, with broader shoulders. Those that deviate from traditions and delve into the mystical arts and culture of the broader world are the Scholar class, who wield magic with skill, at the cost of a slimness of form and a shorter wingspan. 

The Dragonborn were formed as part of the pact between the forces of light and the Dragon-Gods of Aeria. From their unity this race was born, with the form of the elves but with the likeness of the Dragons. 

Most Dragonborn remain in their homes in the mountains north of city, the highest concentration of Dragonborns dwelling in Kar’rasa. Dragonborn that adhere closely to the old ways cherish nature, the world, the self, and the harmony between the three. Those that follow the new ways indulge and embrace knowledge and magic, and frown on anyone they believe is stuck in the past. ]]
Race[ "Dragonborn" ][ "models" ] = {}
Race[ "Dragonborn" ][ "models" ][ "male" ] = {
		            "models/humans/group01/male_01.mdl",
              "models/humans/group01/male_02.mdl",
              "models/humans/group01/male_03.mdl",
              "models/humans/group01/male_04.mdl",
			  "models/humans/group01/male_05.mdl",
              "models/humans/group01/male_06.mdl",
              "models/humans/group01/male_07.mdl",
              "models/humans/group01/male_08.mdl",
              "models/humans/group01/male_09.mdl",
              "models/humans/group02/male_01.mdl",
              "models/humans/group02/male_02.mdl",
              "models/humans/group02/male_03.mdl",
              "models/humans/group02/male_04.mdl",
			   "models/humans/group02/male_05.mdl",
              "models/humans/group02/male_06.mdl",
              "models/humans/group02/male_07.mdl",
              "models/humans/group02/male_08.mdl",
              "models/humans/group02/male_09.mdl"
	      }
Race[ "Dragonborn" ][ "models" ][ "female" ] = {
			  "models/Humans/Group01/Female_01.mdl",
              "models/Humans/Group01/Female_02.mdl",
              "models/Humans/Group01/Female_03.mdl",
              "models/Humans/Group01/Female_04.mdl",
              "models/Humans/Group01/Female_06.mdl",
              "models/Humans/Group01/Female_07.mdl",
              "models/Humans/Group02/Female_01.mdl",
              "models/Humans/Group02/Female_02.mdl",
              "models/Humans/Group02/Female_03.mdl",
              "models/Humans/Group02/Female_04.mdl",
              "models/Humans/Group02/Female_06.mdl",
              "models/Humans/Group02/Female_07.mdl"
	      }
		  
Race[ "Aasimar" ] = {}
Race[ "Aasimar" ][ "desc" ] = [[ Proud, fair skinned and tall, the Aasimar are a race with a somewhat curious background. One of the two races that are known to be Planetouched, the others being the Tieflings, Aasimar are native to planes of law and order. They have holy blood somewhere in their ancestry, but should not be confused with half-celestials, as the celestial heritage is far back in the character's ancestry (at least 1/8th). While some claim to have descended directly from the Gods, it is more likely that one of their ancestors was a Celestial, and not a God. However, most of them cannot trace their heritage back to a specific celestial being.

There is no difference between Aasimar hailing from Human, Elven or other lineage, it is the touch of the divine that makes them what they are, regardless of their other ancestry.

Most Aasimar have a Human ancestry, a relative few have an Elvish ancestry. Aasimar have no lands to call their own. They are welcome in most places, but can also be unwanted in others. Having no home or lands to call their own, Aasimar travel the lands and are not likely to settle down in a particular location. They’re usually traveling paladins or clerics, looking to fight evil where they can. Those who are not devout followers of a Deity, tend to become traveling bards.
 ]]
Race[ "Aasimar" ][ "models" ] = {}
Race[ "Aasimar" ][ "models" ][ "male" ] = {
		            "models/humans/group01/male_01.mdl",
              "models/humans/group01/male_02.mdl",
              "models/humans/group01/male_03.mdl",
              "models/humans/group01/male_04.mdl",
			  "models/humans/group01/male_05.mdl",
              "models/humans/group01/male_06.mdl",
              "models/humans/group01/male_07.mdl",
              "models/humans/group01/male_08.mdl",
              "models/humans/group01/male_09.mdl",
              "models/humans/group02/male_01.mdl",
              "models/humans/group02/male_02.mdl",
              "models/humans/group02/male_03.mdl",
              "models/humans/group02/male_04.mdl",
			   "models/humans/group02/male_05.mdl",
              "models/humans/group02/male_06.mdl",
              "models/humans/group02/male_07.mdl",
              "models/humans/group02/male_08.mdl",
              "models/humans/group02/male_09.mdl"
	      }
Race[ "Aasimar" ][ "models" ][ "female" ] = {
			  "models/Humans/Group01/Female_01.mdl",
              "models/Humans/Group01/Female_02.mdl",
              "models/Humans/Group01/Female_03.mdl",
              "models/Humans/Group01/Female_04.mdl",
              "models/Humans/Group01/Female_06.mdl",
              "models/Humans/Group01/Female_07.mdl",
              "models/Humans/Group02/Female_01.mdl",
              "models/Humans/Group02/Female_02.mdl",
              "models/Humans/Group02/Female_03.mdl",
              "models/Humans/Group02/Female_04.mdl",
              "models/Humans/Group02/Female_06.mdl",
              "models/Humans/Group02/Female_07.mdl"
	      }
		  
Race[ "Goblin" ] = {}
Race[ "Goblin" ][ "desc" ] = [[ A goblin is an crabby, and mischievous creature described as a grotesquely disfigured or gnome-like phantom, that may range in height from that of a dwarf to that of a human. They are attributed with various (sometimes conflicting) abilities, temperaments and appearances. Goblins aren't smaller cousins of orcs, but are a part of the related species collectively referred to as goblinoids. Goblinoids include hobgoblins, bugbears, and others.

Goblins are small humanoid monsters.They come in many shapes and sizes, often depending on the region and habitat one is looking in. Typically though, they are classified into four different groups, despite all being of the same race. (Suggested you go down and read “Tiers” first)

Surface goblins are the most commonly found. Often located in either grasslands or wooded zones, they tend to have green pigmented skin and stand the tallest of the Goblins, reaching anywhere from 4 ½ feet to a whopping 6 feet tall. They often live in more tribal settings usually only reaching tier two or three (See goblin society: Tiers). Their equipment is often rudimentary, being either made by their smithies and fletchers, or traded/stolen from nearby towns. Surface goblins, while lacking any metalwork skills can create quite impressive bows and skirmish weapons, as leather and wood is easier to come by then ores on the surface and are considered to be highly effective hunters and trackers.
 ]]
Race[ "Goblin" ][ "models" ] = {}
Race[ "Goblin" ][ "models" ][ "male" ] = {
		    "models/goblin/goblin.mdl",
	      }
Race[ "Goblin" ][ "models" ][ "female" ] = {
			  "models/Humans/Group01/Female_01.mdl",
              "models/Humans/Group01/Female_02.mdl",
              "models/Humans/Group01/Female_03.mdl",
              "models/Humans/Group01/Female_04.mdl",
              "models/Humans/Group01/Female_06.mdl",
              "models/Humans/Group01/Female_07.mdl",
              "models/Humans/Group02/Female_01.mdl",
              "models/Humans/Group02/Female_02.mdl",
              "models/Humans/Group02/Female_03.mdl",
              "models/Humans/Group02/Female_04.mdl",
              "models/Humans/Group02/Female_06.mdl",
              "models/Humans/Group02/Female_07.mdl"
	      }
		  
Race[ "Orc" ] = {}
Race[ "Orc" ][ "desc" ] = [[These brutish thugs were born to kill. Without remorse or feeling they slaughter anything and everything in their paths. Crude weaponry and armor forged from iron and steel they are a common enemy of the peoples of Olden land. Many times they can be found in rather large cities of wooden structures and forts hidden within small valleys or crevices in the earth. No matter what race you are human, gnome, dwarf, or kazuth you are always in danger from these monsters. Even their own kind is threatened. The children and runts of the orcish tribes are known for being picked on and killed due to their flaws in the culture. Usually, like spartans, any orc or otherwise is killed brutally for being a runt or even just being smarter then the others.

These creatures have a green skin color the often varies from olive green to forest green. Their style isn’t any better then their charisma, they were tattered loincloths made from hides or other such things when they are not preparing for battle. When ready for battle they often wear a sturdy suit of plate mail made of iron or steel, depending on which has the most local materials. Usually orcs employ heavy weapons such as hammers, great swords, pickaxes, and just straight up axes. More over, their taste of weaponry is crude and old, often just taken from villages and caravans they have raided in the past.

Their intelligence is low disabling them from using magic or just reading in general. The Orcish culture is very simplistic; kill, eat, sleep, mate, kill. This agenda is blunt and effective for their race. Although they may be seen as idiots to the masses they have their own written language and speak in broken English.
 ]]
Race[ "Orc" ][ "models" ] = {}
Race[ "Orc" ][ "models" ][ "male" ] = {
		            "models/humans/group01/male_01.mdl",
              "models/humans/group01/male_02.mdl",
              "models/humans/group01/male_03.mdl",
              "models/humans/group01/male_04.mdl",
			  "models/humans/group01/male_05.mdl",
              "models/humans/group01/male_06.mdl",
              "models/humans/group01/male_07.mdl",
              "models/humans/group01/male_08.mdl",
              "models/humans/group01/male_09.mdl",
              "models/humans/group02/male_01.mdl",
              "models/humans/group02/male_02.mdl",
              "models/humans/group02/male_03.mdl",
              "models/humans/group02/male_04.mdl",
			   "models/humans/group02/male_05.mdl",
              "models/humans/group02/male_06.mdl",
              "models/humans/group02/male_07.mdl",
              "models/humans/group02/male_08.mdl",
              "models/humans/group02/male_09.mdl"
	      }
Race[ "Orc" ][ "models" ][ "female" ] = {
			  "models/Humans/Group01/Female_01.mdl",
              "models/Humans/Group01/Female_02.mdl",
              "models/Humans/Group01/Female_03.mdl",
              "models/Humans/Group01/Female_04.mdl",
              "models/Humans/Group01/Female_06.mdl",
              "models/Humans/Group01/Female_07.mdl",
              "models/Humans/Group02/Female_01.mdl",
              "models/Humans/Group02/Female_02.mdl",
              "models/Humans/Group02/Female_03.mdl",
              "models/Humans/Group02/Female_04.mdl",
              "models/Humans/Group02/Female_06.mdl",
              "models/Humans/Group02/Female_07.mdl"
	      }
		  
Race[ "Elf" ] = {}
Race[ "Elf" ][ "desc" ] = [[Usually aller than the average human, elves are also noticeably more slender and graceful, averaging between 6 1/2 to 7 1/2 feet and 105 to 185 pounds. Males are slightly more muscular on average, there is little difference in height between the sexes, and neither sex grows facial hair. Their features in general may be described as more angular and defined; including long, pointed ears and wide, almond-shaped eyes. Most elves have fair skin and dark hair, though this is no more true of all elves than it is of humans. They have a reputation for careful grooming, more so than perhaps any other race. This frequently extends to their clothing, which is luxurious and well-kept, though not to the point of impracticality.

Elves do not sleep as most other creatures do, instead falling into a four-hour restful trance. Consequently, elves are unaffected by sleep-inducing spells and effects, and are able to remain active far longer than other races.

Elves also do not age as other creatures; their physical appearances remain constant from achieving physical maturity to death. Elves do grow physically weaker and mentally stronger as they grow older, and accumulate a "glow" from the strength of their souls as they age.
 ]]
Race[ "Elf" ][ "models" ] = {}
Race[ "Elf" ][ "models" ][ "male" ] = {
		            "models/humans/group01/male_01.mdl",
              "models/humans/group01/male_02.mdl",
              "models/humans/group01/male_03.mdl",
              "models/humans/group01/male_04.mdl",
			  "models/humans/group01/male_05.mdl",
              "models/humans/group01/male_06.mdl",
              "models/humans/group01/male_07.mdl",
              "models/humans/group01/male_08.mdl",
              "models/humans/group01/male_09.mdl",
              "models/humans/group02/male_01.mdl",
              "models/humans/group02/male_02.mdl",
              "models/humans/group02/male_03.mdl",
              "models/humans/group02/male_04.mdl",
			   "models/humans/group02/male_05.mdl",
              "models/humans/group02/male_06.mdl",
              "models/humans/group02/male_07.mdl",
              "models/humans/group02/male_08.mdl",
              "models/humans/group02/male_09.mdl"
	      }
Race[ "Elf" ][ "models" ][ "female" ] = {
			  "models/Humans/Group01/Female_01.mdl",
              "models/Humans/Group01/Female_02.mdl",
              "models/Humans/Group01/Female_03.mdl",
              "models/Humans/Group01/Female_04.mdl",
              "models/Humans/Group01/Female_06.mdl",
              "models/Humans/Group01/Female_07.mdl",
              "models/Humans/Group02/Female_01.mdl",
              "models/Humans/Group02/Female_02.mdl",
              "models/Humans/Group02/Female_03.mdl",
              "models/Humans/Group02/Female_04.mdl",
              "models/Humans/Group02/Female_06.mdl",
              "models/Humans/Group02/Female_07.mdl"
	      }
Race[ "Gnome" ] = {}
Race[ "Gnome" ][ "desc" ] = [[Gnomes have an intricate society based on their love of all kinds of arts, pranks, and their long lives. Their society is based on art; all gnomes must take up some form of art whether music, painting, cooking, building, or any other form that is considered creative by the time they come of age.

Gnomes are naturally friendly, highly social and fun loving people. They are respected by Elves for their communion with nature and knowledge of arcane magic, admired by Halflings for their humor, and sought out by Dwarves for their gemcutting skills.

Mothers give birth at home and the birthing chamber is open only to the father and a favored professional, like an herbalist, midwife or physician. They alone will assist the mother. The first and last names are given at the time of birth by the parents. However, gnome births are cause for a family gathering.

Beyond the birthing chamber, a cleric and numerous friends and relations gather to await the newborn’s arrival. Many names will be given to the child this day. Any member of the community can offer a name.

Additional names are given throughout a gnome’s lifetime. They are usually descriptive of the person but can also be given in playful jest. Gnomes have exceptionally long names by the standards of other races. For this reason, gnomes will chose a name with which they prefer to be identified. Often this name is chosen for its ridiculousness or difficulty in pronunciation.

Gnome communities are small and close knit. A sane gnome would never consider trespassing on another beyond the usual practical joke. Gnome criminals are considered insane and are treated by alchemists, clerics and magicians until cured. ]]
Race[ "Gnome" ][ "models" ] = {}
Race[ "Gnome" ][ "models" ][ "male" ] = {
		            "models/humans/group01/male_01.mdl",
              "models/humans/group01/male_02.mdl",
              "models/humans/group01/male_03.mdl",
              "models/humans/group01/male_04.mdl",
			  "models/humans/group01/male_05.mdl",
              "models/humans/group01/male_06.mdl",
              "models/humans/group01/male_07.mdl",
              "models/humans/group01/male_08.mdl",
              "models/humans/group01/male_09.mdl",
              "models/humans/group02/male_01.mdl",
              "models/humans/group02/male_02.mdl",
              "models/humans/group02/male_03.mdl",
              "models/humans/group02/male_04.mdl",
			   "models/humans/group02/male_05.mdl",
              "models/humans/group02/male_06.mdl",
              "models/humans/group02/male_07.mdl",
              "models/humans/group02/male_08.mdl",
              "models/humans/group02/male_09.mdl"
	      }
Race[ "Gnome" ][ "models" ][ "female" ] = {
			  "models/Humans/Group01/Female_01.mdl",
              "models/Humans/Group01/Female_02.mdl",
              "models/Humans/Group01/Female_03.mdl",
              "models/Humans/Group01/Female_04.mdl",
              "models/Humans/Group01/Female_06.mdl",
              "models/Humans/Group01/Female_07.mdl",
              "models/Humans/Group02/Female_01.mdl",
              "models/Humans/Group02/Female_02.mdl",
              "models/Humans/Group02/Female_03.mdl",
              "models/Humans/Group02/Female_04.mdl",
              "models/Humans/Group02/Female_06.mdl",
              "models/Humans/Group02/Female_07.mdl"
	      }
		  
Race[ "Kazuth" ] = {}
Race[ "Kazuth"  ][ "desc" ] = [[The Kazuth are humanoid folk with some of the traits of felines. They are nearly identical to normal humans, enough that with a few simple cosmetic adjustments, a Kazuth could easily feign normal humanity. The most obvious and most universal traits that set Kazuth apart from humans are catlike ears and a feline tail. Color, fur texture, and patterns vary from Kazuth to Kazuth. 

Though the Kazuth have no nation to call their own, they are spread all over the world, dwelling in nearly every nation and environment in the mortal realm, with varying amounts of success. Sida values a specific breed of them as slaves, for use in either labor or war; Talibar has the greatest number of ‘city-bred’ Kazuth in the world, though there is a great amount of racism for their reputation as swindlers, cutthroats and thieves; the few Kazuth that live or are born in Occitan are forced to hide their features or face discrimination and violence at every level of society; in Sarkun, they have dwelt successfully in warrior tribes, alongside the Lizardmen. 

The speed of Kazuth birth and death (Kazuth tend to live, at the most, fifty years) has resulted in the creation of different breeds of Kazuth. The ‘Desert-Tiger’ tribes of Sida are feared as warriors yet greatly valued, if one could be captured, as slaves: these Kazuth are heavily built, who can grow to be as large as a Dragonborn at six feet tall, with predatory teeth and claws, and are colored white with trimmed fur all over their bodies to blend into the desert sands.  The ‘city-bred’ Kazuth are perhaps the most iconic breed; most numerous in Talibar, these Kazuth lack fur save on their tails and ears, and with light bones and builds, they are very fast and dexterous, though they are quite small. City-Bred Kazuth have the greatest variance in color and markings.The so-called ‘Jaguar’ tribes of Sarkun are lithe, quick, and tall, and excel in spears and hunting. They have brown, ragged fur, and often enhance their markings with tribal paint.
 ]]
Race[ "Kazuth"  ][ "models" ] = {}
Race[ "Kazuth"  ][ "models" ][ "male" ] = {
		            "models/humans/group01/male_01.mdl",
              "models/humans/group01/male_02.mdl",
              "models/humans/group01/male_03.mdl",
              "models/humans/group01/male_04.mdl",
			  "models/humans/group01/male_05.mdl",
              "models/humans/group01/male_06.mdl",
              "models/humans/group01/male_07.mdl",
              "models/humans/group01/male_08.mdl",
              "models/humans/group01/male_09.mdl",
              "models/humans/group02/male_01.mdl",
              "models/humans/group02/male_02.mdl",
              "models/humans/group02/male_03.mdl",
              "models/humans/group02/male_04.mdl",
			   "models/humans/group02/male_05.mdl",
              "models/humans/group02/male_06.mdl",
              "models/humans/group02/male_07.mdl",
              "models/humans/group02/male_08.mdl",
              "models/humans/group02/male_09.mdl"
	      }
Race[ "Kazuth"  ][ "models" ][ "female" ] = {
			  "models/Humans/Group01/Female_01.mdl",
              "models/Humans/Group01/Female_02.mdl",
              "models/Humans/Group01/Female_03.mdl",
              "models/Humans/Group01/Female_04.mdl",
              "models/Humans/Group01/Female_06.mdl",
              "models/Humans/Group01/Female_07.mdl",
              "models/Humans/Group02/Female_01.mdl",
              "models/Humans/Group02/Female_02.mdl",
              "models/Humans/Group02/Female_03.mdl",
              "models/Humans/Group02/Female_04.mdl",
              "models/Humans/Group02/Female_06.mdl",
              "models/Humans/Group02/Female_07.mdl"
	      }
		  
Race[ "Other" ] = {}
Race[ "Other"  ][ "desc" ] = [[ A race that doesn't fit the description of those listed here. Please specify which on your title.
]]
Race[ "Other"  ][ "models" ] = {}
Race[ "Other"  ][ "models" ][ "male" ] = {
		            "models/humans/group01/male_01.mdl",
              "models/humans/group01/male_02.mdl",
              "models/humans/group01/male_03.mdl",
              "models/humans/group01/male_04.mdl",
			  "models/humans/group01/male_05.mdl",
              "models/humans/group01/male_06.mdl",
              "models/humans/group01/male_07.mdl",
              "models/humans/group01/male_08.mdl",
              "models/humans/group01/male_09.mdl",
              "models/humans/group02/male_01.mdl",
              "models/humans/group02/male_02.mdl",
              "models/humans/group02/male_03.mdl",
              "models/humans/group02/male_04.mdl",
			   "models/humans/group02/male_05.mdl",
              "models/humans/group02/male_06.mdl",
              "models/humans/group02/male_07.mdl",
              "models/humans/group02/male_08.mdl",
              "models/humans/group02/male_09.mdl"
	      }
Race[ "Other"  ][ "models" ][ "female" ] = {
			  "models/Humans/Group01/Female_01.mdl",
              "models/Humans/Group01/Female_02.mdl",
              "models/Humans/Group01/Female_03.mdl",
              "models/Humans/Group01/Female_04.mdl",
              "models/Humans/Group01/Female_06.mdl",
              "models/Humans/Group01/Female_07.mdl",
              "models/Humans/Group02/Female_01.mdl",
              "models/Humans/Group02/Female_02.mdl",
              "models/Humans/Group02/Female_03.mdl",
              "models/Humans/Group02/Female_04.mdl",
              "models/Humans/Group02/Female_06.mdl",
              "models/Humans/Group02/Female_07.mdl"
	      }

local selectedrace = ""

local Deity = "None"
local Alignment = "True Neutral"
local Age = "30"
local models = {}
local Birthplace = "Surna"
local Height = 150
local Gender = "Male"
local Title1 = "Title1"
local Title2 = "Title2"
local FirstName = "Set Your"
local LastName = "Name"
local Description = "Set your description"

function firststep()
		      
	      --Step 1
	      Step1 = vgui.Create( "DFrame" )
	      Step1:SetPos( ScrW() / 2 - 320, ScrH() / 2 - 240 )
	      Step1:SetSize( 700, 450 )
	      Step1:SetTitle( "Step 1" )
	      Step1:SetVisible( true )
	      Step1:SetDraggable( true )
	      Step1:ShowCloseButton( true )
	      Step1:MakePopup()
	      
	      Step1Panel = vgui.Create( "DPanel", Step1 )
	      Step1Panel:SetPos( 2, 23 )
	      Step1Panel:SetSize( 698, 375 )
	      Step1Panel.Paint = function()
		      surface.SetDrawColor( 50, 50, 50, 255 )
		      surface.DrawRect( 0, 0, Step1Panel:GetWide(), Step1Panel:GetTall() )
	      end
	      
	      local label = vgui.Create( "DLabel", Step1Panel )
	      label:SetPos( 5, 3 )
	      label:SetSize( 150, 20 )
	      label:SetText( "Select your race and press OK" )
	      
	      RaceBox = vgui.Create( "DComboBox", Step1Panel )
	      RaceBox:SetPos( 5, 20 )
	      RaceBox:SetSize( 150, 350 )
	      RaceBox:SetMultiple( false )
	      
	      for k, v in pairs ( Race ) do
		      RaceBox:AddItem( k )
	      end
	      
	      RaceBox:SelectByName( "Human" )
	      local DescText = vgui.Create( "DTextEntry", Step1Panel )
	      DescText:SetPos( 170, 20 )
	      DescText:SetSize( 500, 350 )
	      DescText:SetMultiline( true )
	      DescText:SetEditable( false )
	      function RaceBox:Think()
		      if RaceBox:GetSelectedItems() and RaceBox:GetSelectedItems()[1] then
			      DescText:SetText( Race[ RaceBox:GetSelectedItems()[1]:GetValue() ][ "desc" ] )
		      else
			      DescText:SetText( "Select a race to Continue!" )
		      end	      
	      end
	      local AcceptButton = vgui.Create( "DButton", Step1 )
	      AcceptButton:SetSize( 200, 50)
	      AcceptButton:SetText( "Continue to next step" )
	      AcceptButton:SetPos( 250, 400 )
	      AcceptButton.DoClick = function ( btn )
			   if( not RaceBox:GetSelectedItems() ) then
				   ErrorMessage( "You must select a race to continue" )
				   return;
			   end
			   selectedrace = tostring( RaceBox:GetSelectedItems()[1]:GetValue() )
			   models = Race[ RaceBox:GetSelectedItems()[1]:GetValue() ][ "models" ] 
			   Step1:Remove();
			   Step1 = nil;
        secondstep()
	   end
	      
end

function secondstep()
	      Step2 = vgui.Create( "DFrame" )
	      Step2:SetPos( ScrW() / 2 - 320, ScrH() / 2 - 240 )
	      Step2:SetSize( 700, 450 )
	      Step2:SetTitle( "Step 2" )
	      Step2:SetVisible( true )
	      Step2:SetDraggable( true )
	      Step2:ShowCloseButton( true )
	      Step2:MakePopup()

	      Step2Panel = vgui.Create( "DPanel", Step2 )
	      Step2Panel:SetPos( 2, 23 )
	      Step2Panel:SetSize( 698, 433 )
	      Step2Panel.Paint = function()
		      surface.SetDrawColor( 50, 50, 50, 255 )
		      surface.DrawRect( 0, 0, Step2Panel:GetWide(), Step2Panel:GetTall() )
	      end
	      
	      NewPanel = vgui.Create( "DPanelList", Step2Panel )
	      NewPanel:SetPos( 5,0 )
	      NewPanel:SetSize( 330, 375 )
	      NewPanel:SetSpacing( 5 ) -- Spacing between items
	      NewPanel:EnableHorizontal( false ) -- Only vertical items
	      NewPanel:EnableVerticalScrollbar( false ) -- Allow scrollbar if you exceed the Y axis
	      
	      local info = vgui.Create( "DForm" );
	      info:SetName("Personal Information");
	      info:SetSpacing( 3 )
	      NewPanel:AddItem(info);

	      local label = vgui.Create("DLabel");
	      info:AddItem(label);
	      label:SetSize(30,25);
	      label:SetPos(150, 50);
	      label:SetText("First: ");

	      local firstname = vgui.Create("DTextEntry");
	      info:AddItem(firstname);
	      firstname:SetSize(100,25);
	      firstname:SetPos(185, 50);
	      firstname:SetText(FirstName);

	      local label = vgui.Create("DLabel");
	      info:AddItem(label);
	      label:SetSize(30,25);
	      label:SetPos(5, 50);
	      label:SetText("Last: ");

	      local lastname = vgui.Create("DTextEntry");
	      info:AddItem(lastname);
	      lastname:SetSize(100,25);
	      lastname:SetPos(40, 50);
	      lastname:SetText(LastName);

	      local label = vgui.Create("DLabel");
	      info:AddItem(label);
	      label:SetSize(100,25);
	      label:SetPos(5, 80);
	      label:SetText("Title: ");

	      local title = vgui.Create("DTextEntry");
	      info:AddItem(title);
	      title:SetSize(205, 25);
	      title:SetPos(80, 80);
	      title:SetText(Title1);
	      
	      local label = vgui.Create("DLabel");
	      info:AddItem(label);
	      label:SetSize(100,25);
	      label:SetPos(5, 80);
	      label:SetText("Title 2: ");

	      local title2 = vgui.Create("DTextEntry");
	      info:AddItem(title2);
	      title2:SetSize(205, 25);
	      title2:SetPos(80, 80);
	      title2:SetText(Title2);
	      
	      local label = vgui.Create("DLabel");
	      info:AddItem(label);
	      label:SetSize(30,25);
	      label:SetPos(150, 50);
	      label:SetText("Gender");
	      
	      local MenuButton = vgui.Create("DButton")
	      MenuButton:SetText( "Gender" )
	      MenuButton:SetPos(25, 50)
	      MenuButton:SetSize( 190, 25 )
	      MenuButton.DoClick = function ( btn )
			   local MenuButtonOptions = DermaMenu()
			   MenuButtonOptions:AddOption( "Male", function() 
				   Gender = "Male"
			   end)
			   MenuButtonOptions:AddOption( "Female", function() 
				   Gender = "Female"
			   end )
		      MenuButtonOptions:Open()
	      end 
	      info:AddItem(MenuButton);

	      local label = vgui.Create("DLabel");
	      info:AddItem(label);
	      label:SetSize(30,25);
	      label:SetPos(150, 50);
	      label:SetText("Age: ");
	      
	      local numberwang = vgui.Create( "DNumberWang" )
	      info:AddItem(numberwang);
	      numberwang:SetSize(30,25);
	      numberwang:SetMin( 8 )
	      numberwang:SetMax( 89 )
	      numberwang:SetDecimals( 0 )
	      
	      Looks = vgui.Create( "DPanelList", Step2Panel )
	      Looks:SetPos( 343, 0 )
	      Looks:SetSize( 349, 375 )
	      Looks:SetSpacing( 5 ) -- Spacing between items
	      Looks:EnableHorizontal( false ) -- Only vertical items
	      Looks:EnableVerticalScrollbar( true ) -- Allow scrollbar if you exceed the Y axis
	      
	      local appearance = vgui.Create( "DForm" );
	      appearance:SetName("Appearance and Extra");
	      Looks:AddItem(appearance);
	      
	      local label = vgui.Create("DLabel");
	      appearance:AddItem(label);
	      label:SetSize(30,25);
	      label:SetPos(150, 50);
	      label:SetText("Description");
	      
	      local desc = vgui.Create("DTextEntry");
	      appearance:AddItem(desc);
	      desc:SetSize(305, 50);
	      desc:SetMultiline( true )
	      desc:SetPos(80, 80);
	      desc:SetText( Description );
	      
	      local heightlabel = vgui.Create("DLabel");
	      heightlabel:SetSize(30,25);
	      heightlabel:SetPos(150, 50);
	      heightlabel:SetText("No height selected yet." );
	      
	      local HeightSlider = vgui.Create("DNumSlider");
	      HeightSlider:SetMax( 200 );
	      HeightSlider:SetMin( 120 );
	      HeightSlider:SetText("Height");
	      HeightSlider:SetDecimals( 0 );
	      HeightSlider:SetWidth(300);
	      HeightSlider:SetPos(50, 590);
	      appearance:AddItem(HeightSlider);
	      HeightSlider.OnValueChanged = function()
		      local feet = math.floor( HeightSlider:GetValue() / 30 )
		      local fakeinches = HeightSlider:GetValue() - feet * 30
		      heightlabel:SetText("Metric: " .. HeightSlider:GetValue() / 100 .. " meters. Imperial: " .. tostring( feet ) .. "feet " .. tostring( fakeinches / 2.5 ) .. " inches." );
	      end
	      appearance:AddItem(heightlabel);
	      
/*	      local deitylabel = vgui.Create("DLabel");
	      deitylabel:SetSize(30,25);
	      deitylabel:SetPos(150, 50);
	      deitylabel:SetText(Deity .. ":" .. DeityDesc[ Deity ]);
	      deitylabel:SetAutoStretchVertical( true )
	      
	      local MenuButton = vgui.Create("DButton")
	      MenuButton:SetText( "Deity" )
	      MenuButton:SetPos(25, 50)
	      MenuButton:SetSize( 190, 25 )
	      MenuButton.DoClick = function ( btn )
	      local MenuButtonOptions = DermaMenu()
		      for k, v in pairs( DeityDesc ) do
			      MenuButtonOptions:AddOption( k, function()
				      Deity = k
				      deitylabel:SetText(Deity .. ":" .. DeityDesc[ Deity ]);
			      end )
		      end
		      MenuButtonOptions:Open()
	      end 
	      appearance:AddItem(MenuButton);
	      appearance:AddItem(deitylabel);*/
	      
	      local label = vgui.Create("DLabel");
	      appearance:AddItem(label);
	      label:SetSize(30,25);
	      label:SetPos(150, 50);
	      label:SetText(" ");
	      
	      local AlignmentButton = vgui.Create("DButton")
	      AlignmentButton:SetText( "Alignment" )
	      AlignmentButton:SetPos(25, 50)
	      AlignmentButton:SetSize( 190, 25 )
	      AlignmentButton.DoClick = function ( btn )
	      local AlignmentOptions = DermaMenu()
		      AlignmentOptions:AddOption("Lawful Good", function() 
		      Alignment = "Lawful Good"
	      end )
		      AlignmentOptions:AddOption("Neutral Good", function() 
		      Alignment = "Neutral Good"
	      end )
		      AlignmentOptions:AddOption("Chaotic Good", function() 
		      Alignment = "Chaotic Good"
	      end )
		      AlignmentOptions:AddOption("Lawful Neutral", function() 
		      Alignment = "Lawful Neutral"
	      end )
		      AlignmentOptions:AddOption("True Neutral", function() 
		      Alignment = "True Neutral"
	      end )
		      AlignmentOptions:AddOption("Chaotic Neutral", function() 
		      Alignment = "Chaotic Neutral"
	      end )
		      AlignmentOptions:AddOption("Lawful Evil", function() 
		      Alignment = "Lawful Evil"
	      end )
		      AlignmentOptions:AddOption("Neutral Evil", function() 
		      Alignment = "Neutral Evil"
	      end )
		      AlignmentOptions:AddOption("Chaotic Evil", function() 
		      Alignment = "Chaotic Evil"
	      end )
		      AlignmentOptions:Open()
	      end
	      appearance:AddItem( AlignmentButton )
	      
	      local label = vgui.Create("DLabel");
	      appearance:AddItem(label);
	      label:SetSize(30,25);
	      label:SetPos(150, 50);
	      label:SetText("Birthplace:");
	      
	      local birthplace = vgui.Create("DTextEntry");
	      appearance:AddItem(birthplace);
	      birthplace:SetSize(205, 25);
	      birthplace:SetPos(80, 80);
	      birthplace:SetText( Birthplace );
	      
	      local AcceptButton = vgui.Create( "DButton", Step2 )
	      AcceptButton:SetSize( 200, 50)
	      AcceptButton:SetText( "Continue to next step" )
	      AcceptButton:SetPos( 425, 380 )
	      AcceptButton.DoClick = function ( btn )	      
		      if(firstname:GetValue() == "" ) then
			      ErrorMessage( "You must enter a first name!" )
			      return;
		      end
		      
		      if(numberwang:GetValue() < 1 ) then
			      ErrorMessage( "You must enter a valid age!" )
			      return;
		      end
		      
		      if(HeightSlider:GetValue() < 1 ) then
			      ErrorMessage( "You must enter a valid height!" )
			      LocalPlayer():PrintMessage(3, "You must enter a valid height!");
			      return;
		      end
		      
		      Age = tostring( numberwang:GetValue() )
		      Birthplace = string.sub(birthplace:GetValue(), 1, 64)
		      Height = HeightSlider:GetValue() 
		      Title1 = string.sub(title:GetValue(), 1, 64)
		      Title2 = string.sub(title2:GetValue(), 1, 64)
		      FirstName = string.sub(firstname:GetValue(), 1, 64)
		      LastName = string.sub(lastname:GetValue(), 1, 64)
		      Description = string.sub( desc:GetValue(), 1, 230 )
		      Step2:Remove();
		      Step2 = nil;
		      thirdstep()
	      end
	      
	      
	      local GoBackButton = vgui.Create( "DButton", Step2 )
	      GoBackButton:SetSize( 200, 40 )
	      GoBackButton:SetText( "Go back to previous step" )
	      GoBackButton:SetPos( 75, 400 )
	      GoBackButton.DoClick = function( btn )
		      firststep()
		      Step2:Remove();
		      Step2 = nil;
	      end
	      
end

function thirdstep()
	      // Excuse the shittyness, hotfix.
	      
	      local demmodels = {}
	      demmodels = table.Copy( models[ string.lower( Gender ) ] )
	      
	      Step3 = vgui.Create( "DFrame" )
	      Step3:SetPos( ScrW() / 2 - 320, ScrH() / 2 - 400 )
	      Step3:SetSize( 615, 700 )
	      Step3:SetTitle( "Step 3" )
	      Step3:SetVisible( true )
	      Step3:SetDraggable( true )
	      Step3:ShowCloseButton( false )
	      Step3:MakePopup()
	      
	      ModelWindow = vgui.Create( "DPanel", Step3 )
	      
	      local mdlPanel = vgui.Create( "DModelPanel", ModelWindow )
	      mdlPanel:SetSize( 500, 500 )
	      mdlPanel:SetPos( 50, 60 )
			if demmodels and demmodels[1] then
				mdlPanel:SetModel( demmodels[1] )
			end
	      mdlPanel:SetAnimSpeed( 0.0 )
	      mdlPanel:SetAnimated( false )
	      mdlPanel:SetAmbientLight( Color( 50, 50, 50 ) )
	      mdlPanel:SetDirectionalLight( BOX_TOP, Color( 255, 255, 255 ) )
	      mdlPanel:SetDirectionalLight( BOX_FRONT, Color( 255, 255, 255 ) )
	      mdlPanel:SetCamPos( Vector( 50, 0, 50 ) )
	      mdlPanel:SetLookAt( Vector( 0, 0, 50 ) )
	      mdlPanel:SetFOV( 70 )
	      function mdlPanel:Think()
		      SetChosenModel(mdlPanel.Entity:GetModel());
	      end
	      local RotateSlider = vgui.Create("DNumSlider", ModelWindow);
	      RotateSlider:SetMax(360);
	      RotateSlider:SetMin(0);
	      RotateSlider:SetText("Rotate");
	      RotateSlider:SetDecimals( 0 );
	      RotateSlider:SetWidth(500);
	      RotateSlider:SetPos(50, 590);

	      local BodyButton = vgui.Create("DButton", ModelWindow);
	      BodyButton:SetText("Body");
	      BodyButton.DoClick = function()

		      mdlPanel:SetCamPos( Vector( 50, 0, 50) );
		      mdlPanel:SetLookAt( Vector( 0, 0, 50) );
		      mdlPanel:SetFOV( 70 );
		      
	      end
	      BodyButton:SetPos(10, 40);

	      local FaceButton = vgui.Create("DButton", ModelWindow);
	      FaceButton:SetText("Face");
	      FaceButton.DoClick = function()

		      mdlPanel:SetCamPos( Vector( 50, 0, 60) );
		      mdlPanel:SetLookAt( Vector( 0, 0, 60) );
		      mdlPanel:SetFOV( 40 );
		      
	      end
	      FaceButton:SetPos(10, 60);

	      local FarButton = vgui.Create("DButton", ModelWindow);
	      FarButton:SetText("Far");
	      FarButton.DoClick = function()
		      mdlPanel:SetCamPos( Vector( 100, 0, 30) );
		      mdlPanel:SetLookAt( Vector( 0, 0, 30) );
		      mdlPanel:SetFOV( 70 );
		      
	      end
	      FarButton:SetPos(10, 80);

	      function mdlPanel:LayoutEntity(Entity)

		      self:RunAnimation()
		      Entity:SetAngles( Angle( 0, RotateSlider:GetValue(), 0) )
		      
	      end

	      local i = 1;
	      
	      local LastMdl = vgui.Create( "DSysButton", ModelWindow )
	      LastMdl:SetType("left");
	      LastMdl.DoClick = function()
		      i = i - 1;
		      
		      if(i == 0) then
			      i = #demmodels;
		      end
		      
		      mdlPanel:SetModel(demmodels[i]);
		      
	      end

	      LastMdl:SetPos(10, 365);

	      local NextMdl = vgui.Create( "DSysButton", ModelWindow )
	      NextMdl:SetType("right");
	      NextMdl.DoClick = function()

		      i = i + 1;

		      if(i > #demmodels) then
			      i = 1;
		      end
		      
		      mdlPanel:SetModel(demmodels[i]);
		      
	      end
	      NextMdl:SetPos( 545, 365);
	      
	      ModelWindow:SetSize( 615, 640 )
	      ModelWindow:SetPos( 0, 23 )
	      ModelWindow.Paint = function()
		      surface.SetDrawColor( 50, 50, 50, 255 )
		      surface.DrawRect( 0, 0, ModelWindow:GetWide(), ModelWindow:GetTall() )
	      end
	      /*ModelPanel = vgui.Create( "DPanelList", NewCharMenu )
	      ModelPanel:SetPos( 0,23 )
	      ModelPanel:SetSize( 420, 660 )
	      ModelPanel:SetSpacing( 5 ) -- Spacing between items
	      ModelPanel:EnableHorizontal( false ) -- Only vertical items
	      ModelPanel:EnableVerticalScrollbar( true ) -- Allow scrollbar if you exceed the Y axis*/
	      
	      local GoBackButton = vgui.Create( "DButton", Step3 )
	      GoBackButton:SetSize( 150, 40 )
	      GoBackButton:SetText( "Go back to previous step" )
	      GoBackButton:SetPos( 75, 660 )
	      GoBackButton.DoClick = function( btn )
		      secondstep()
		      Step3:Remove();
		      Step3 = nil;
	      end
	      
	      local apply = vgui.Create("DButton", Step3);
	      apply:SetSize(150, 40);
	      apply:SetText("Accept, create character");
	      apply:SetPos( 375, 660 )
	      apply.DoClick = function ( btn )

		      /*if(!table.HasValue(models, ChosenModel)) then
			      LocalPlayer():PrintMessage(3, ChosenModel .. " is not a valid model!");
			      return;
		      end*/
		      
		      LocalPlayer():ConCommand("rp_startcreate");
		      LocalPlayer():ConCommand("rp_setmodel \"" .. ChosenModel .. "\"");
		      LocalPlayer():ConCommand("rp_changename \"" .. FirstName .. " " .. LastName .. "\"");
		      LocalPlayer():ConCommand("rp_title " .. Title1 );
		      LocalPlayer():ConCommand("rp_title2 " .. Title2 );
		      LocalPlayer():ConCommand("rp_setrace " .. selectedrace );
		      LocalPlayer():ConCommand("rp_setheight " .. tostring(Height / 180 ) );
		      LocalPlayer():ConCommand("rp_setage " .. Age )
		      LocalPlayer():ConCommand("rp_setbirthplace \"" .. Birthplace .. "\"" )
		      LocalPlayer():ConCommand("rp_setalignment \"" .. Alignment .. "\"" )
		      LocalPlayer():ConCommand("rp_setgender " .. Gender )
		      LocalPlayer():ConCommand("rp_setdescription \"" .. tostring( Description ) .. "\"" )
		      LocalPlayer().MyModel = ""
		      LocalPlayer():ConCommand("rp_finishcreate");
		      
		      Step3:Remove();
		      Step3 = nil;
		      
	      end
end



function CLPLUGIN.Init()

	CAKE.AddStep(firststep)
	CAKE.AddStep(secondstep)
	CAKE.AddStep(thirdstep)
	
end
