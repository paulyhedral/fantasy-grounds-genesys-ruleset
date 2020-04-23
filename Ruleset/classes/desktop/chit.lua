-- MOD: Trenloe November 2013.  Added onLogin handler.

local dragging = false;

local removingchit = "false";  --Flag used to stop removeplayerchit from occurring twice.

local playerchitwindow = nil;
local gmchitwindow = nil;

SPECIAL_MSGTYPE_REFRESHGMCHITS = "refreshgmchits";
SPECIAL_MSGTYPE_REMOVEPLAYERCHIT = "removeplayerchit";

function onInit()
	setHoverCursor("hand");

	if chit then
		setIcon(chit[1] .. "chit");
	end

	if window.getClass() == "playerchit" or window.getClass() == "gmchit" then
		if User.isHost() then
			-- subscribe to the login events so that client side chits can be updated when the player logs in.
			User.onLogin = onLogin;
			-- set up the right-click chit menus - GM only
			registerMenuItem("Clear Pile", "deletealltokens", 1);
			registerMenuItem("Update Player Chits", "broadcast", 7);
		end

		-- Register playerchit window instance for use later in GM forced update.
		if window.getClass() == "playerchit" then
			playerchitwindow = window;
		end

		-- Register gmchit window instance for use later in GM forced update.
		if window.getClass() == "gmchit" then
			gmchitwindow = window;
		end

		-- register special messages
		ChatManager.registerSpecialMessageHandler(SPECIAL_MSGTYPE_REFRESHGMCHITS, handleRefreshgmChits);
		ChatManager.registerSpecialMessageHandler(SPECIAL_MSGTYPE_REMOVEPLAYERCHIT, handleRemovePlayerchits);

		if User.isHost() then
			if chit then
				--Set the destiny chits to the current value in the database
				refreshGmChits();
			end
		end
	end

	if window.getClass() == "woundchit" then
		registerMenuItem("Reset to 1", "erase", 1);
		registerMenuItem("Assign 2 chits", "num2", 2);
	end
end

function refreshGmChits()
	ChatManager.sendSpecialMessage(SPECIAL_MSGTYPE_REFRESHGMCHITS, {});
end

function handleRefreshgmChits(msguser, msgidentity, msgparams)
	local playersidenode = nil;
	local gmsidenode = nil;

	Debug.console("chit.lua: handleRefreshgmChits()  window.getClass() = " .. window.getClass());

	if window.getClass() == "playerchit" then
		-- ensure that we have the light side chit node - create it if it does not exist (e.g. for a new campaign)
		if User.isHost() then
			-- If we are the GM this may be a new campaign, need to create the node if not already there.
			if not playersidenode then
				playersidenode = DB.createNode("playerchit.chits","number");
			end
		end

		-- If we don't have the playerchit node at this point, find it.
		if not playersidenode then
			playersidenode = DB.findNode("playerchit.chits");
		end

		--Debug.console("chit.lua: handleRefreshgmChits() playersidenode.getValue = " .. playersidenode.getValue());

		if playersidenode then
			-- refresh chits here
			if playersidenode.getValue()<=0 then
				setIcon("playerchit0");
			elseif playersidenode.getValue()<8 then
				setIcon("playerchit" .. playersidenode.getValue());
			else
				setIcon("playerchit8more");
			end
		end
	end

	if window.getClass() == "gmchit" then
		-- ensure that we have the light side chit node, create it if it does not exist (e.g. for a new campaign)
		if not gmsidenode then
			gmsidenode = DB.createNode("gmchit.chits","number");
		end
		-- refresh chits here
		if gmsidenode then
			if gmsidenode.getValue()<=0 then
				setIcon("gmchit0");
			elseif gmsidenode.getValue()<8 then
				setIcon("gmchit" .. gmsidenode.getValue());
			else
				setIcon("gmchit8more");
			end
		end
	end
end

function removePlayerchits()
	local msgparams = {};
	msgparams[1] = "true";		--Used as the removingchit flag to ensure that the OOB process only fires once on the GM side.
	ChatManager.sendSpecialMessage(SPECIAL_MSGTYPE_REMOVEPLAYERCHIT, msgparams);
end

function handleRemovePlayerchits(msguser, msgidentity, msgparams)
	-- Can onlt adjust the database as the host
	removingchit = msgparams[1];
	if User.isHost() and  removingchit == "true" then
		local msg = {};
		msg.font = "msgfont";

		-- create  new playerside force node, or find it if it already exists
		playersidenode = DB.createNode("playerchit.chits", "number");
		if playersidenode then
			-- Only remove a chit if there are actually any there to remove
			if playersidenode.getValue() > 0 then
				-- decrease the playerside count
				playersidenode.setValue(playersidenode.getValue() - 1);
				--Debug.console("Playerside use.");
				--msg.text = "Playerside destiny has been decremented to " ..  playersidenode.getValue();
				if msgidentity == "" then
					msg.text = "A player story point chit has been used by  " .. msguser;
				elseif msgidentity == "GM" then
					msg.text = "A player story point chit has been played by the GM on behalf of the players.";
				else
					msg.text = "A player story point chit has been used by  " .. msguser .. ", for character " .. msgidentity;
				end
				ChatManager.deliverMessage(msg);

				-- create new gmside force node, or find it if it already exists
				gmsidenode = DB.createNode("gmchit.chits", "number");
				if gmsidenode then
					-- increase the gmside count
					gmsidenode.setValue(gmsidenode.getValue() + 1);
					--msg.text = "Gmside destiny has been incremented to " ..  gmsidenode.getValue();
					--ChatManager.deliverMessage(msg);
				end
				-- Reset flag to stop further processing of this function until another drag event occurs.
				removingchit = "false";
				msgparams[1] = "false";  --Needed to reset removing chit properly when this function fires again.
				-- Refresh the chits.
				refreshGmChits();
			end
		end
	end
end

function onLogin(username, activated)
	if User.isHost() and activated then
		--Add the player as a holder to the gm chits nodes - this is needed to avoid an error accessing the nodes when a user connects to a campaign DB for the first time.
		--local playersidenode = DB.findNode("playerchit");
		--if not playersidenode then
		--	playersidenode.addHolder(username);
		--end

		--local gmsidenode = DB.findNode("gmchit");
		--if not gmsidenode then
			--gmsidenode.addHolder(username);
		--end

		--Refresh the client side chit icons
		refreshGmChits();
	end
end

function onMenuSelection(selection)
	if chit then
		if window.getClass() == "playerchit" or window.getClass() == "gmchit" then
			if selection == 1 then
				-- Reset both chit piles to 0
				local msg = {};
				msg.font = "msgfont";

				if window.getClass() == "playerchit" then
					-- create new playerside force node, or find it if it already exists
					playersidenode = DB.createNode("playerchit.chits", "number");
					if playersidenode then
						-- remove all the playerside
						playersidenode.setValue(0);
						msg.text = "Player story points have been decremented to " ..  playersidenode.getValue();
						ChatManager.deliverMessage(msg);
						refreshGmChits();
					end
				end

				if window.getClass() == "gmchit" then
					gmsidenode = DB.createNode("gmchit.chits", "number");
					if gmsidenode then
						-- remove all the gmside
						gmsidenode.setValue(0);
						msg.text = "GM story points have been decremented to " ..  gmsidenode.getValue();
						ChatManager.deliverMessage(msg);
						refreshGmChits();
					end
				end
			elseif selection == 7 then
				-- Synchronise the chit piles with the connected players - added for the rare occasion where the client does not synch properly on login
				refreshGmChits();
			end
		end

		if window.getClass() == "woundchit" then
			if selection == 1 then

			elseif selection == 2 then

			end
		end
	end
end

function onDragStart(button, x, y, draginfo)
	if window.getClass() == "playerchit" or window.getClass() == "gmchit" then
		-- Allow all users to drag playerside gm chits
		if window.getClass() == "playerchit" then
			dragging = false;
			return onDrag(button, x, y, draginfo);

		--Allow GM to drag both playerside and gmside
		elseif User.isHost() then
			dragging = false;
			return onDrag(button, x, y, draginfo);
		end
	else
		dragging = false;
		return onDrag(button, x, y, draginfo);
	end
end

function onDrag(button, x, y, draginfo)
	if chit and not dragging then
		draginfo.setType("chit");
		draginfo.setDescription(chit[1]);
		draginfo.setIcon(chit[1] .. "chit");
		draginfo.setCustomData(chit[1]);
		dragging = true;
		return true;
	end
end

function onDragEnd(draginfo)
	dragging = false;
	if chit then
		local msg = {};
		msg.font = "msgfont";

		if window.getClass() == "playerchit" then
			removePlayerchits();
		end

		if window.getClass() == "gmchit" then
			gmsidenode = DB.createNode("gmchit.chits", "number");
			if gmsidenode then
				-- Only remove a chit if there are actually any there to remove
				if gmsidenode.getValue() > 0 then
					-- decrease the gmside count
					gmsidenode.setValue(gmsidenode.getValue() - 1);
					--msg.text = "Gmside gm has been decremented to " ..  gmsidenode.getValue();
					msg.text = "A GM story point chit has been used by the GM";
					ChatManager.deliverMessage(msg);
					-- create  new playerside force node, or find it if it already exists
					playersidenode = DB.createNode("playerchit.chits", "number");
					if playersidenode then
						-- increase the playerside count
						playersidenode.setValue(playersidenode.getValue() + 1);
						--msg.text = "Playerside destiny has been incremented to " ..  playersidenode.getValue();
						--ChatManager.deliverMessage(msg);
					end
					refreshGmChits();
				end
			end
		end
	end
end

function onDoubleClick(x, y)
	--Only process if the user is the GM
	if chit and User.isHost() then
		local msg = {};
		msg.font = "msgfont";

		if window.getClass() == "playerchit" then
			-- create  new playerside force node, or find it if it already exists
			playersidenode = DB.findNode("playerchit.chits", "number");
			if not playersidenode then
				playersidenode = DB.createNode("playerchit.chits", "number");
			end
			if playersidenode then
				-- increase the playerside count
				playersidenode.setValue(playersidenode.getValue() + 1);
				--msg.text = "Playerside destiny has been increased to " ..  playersidenode.getValue();
				--ChatManager.deliverMessage(msg);
			end
			-- Initiate special message functionality to refresh chits on clients.
			refreshGmChits();
		end

		if window.getClass() == "gmchit" then
			-- create  new gmside force node, or find it if it already exists
			playersidenode = DB.createNode("playerchit.chits", "number");
			gmsidenode = DB.createNode("gmchit.chits", "number");
			if gmsidenode then
				-- increase the gmside count
				gmsidenode.setValue(gmsidenode.getValue() + 1);
				--msg.text = "Gmside destiny has been increased to " ..  gmsidenode.getValue();
				--ChatManager.deliverMessage(msg);
			end
			-- Initiate special message functionality to refresh chits on clients.
			refreshGmChits();
		end

		return true;
	end
end
