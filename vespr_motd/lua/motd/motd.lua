if CLIENT then
    local serverNameFrame
    local motdFrame
    local closeButton

    local function createFrames()
        serverNameFrame = vgui.Create("DFrame")
        serverNameFrame:SetSize(600, 56)
        serverNameFrame:SetTitle("")
        serverNameFrame:SetPos((ScrW() - serverNameFrame:GetWide()) / 2, ScrH() / 4 - 6)
        serverNameFrame:SetVisible(true)
        serverNameFrame:SetDraggable(false)
        serverNameFrame:ShowCloseButton(false)
        serverNameFrame:MakePopup()

        serverNameFrame.Paint = function(self, w, h)
            draw.RoundedBoxEx(8, 0, 0, w, 6, Color(52, 152, 219), true, true, true, true)
            draw.RoundedBox(0, 0, 6, w, h - 6, Color(36, 37, 42))
        end

        local serverNameLabel = vgui.Create("DLabel", serverNameFrame)
        serverNameLabel:SetText("Vespr MOTD 1.0.2")
        serverNameLabel:SetFont("DermaLarge")
        serverNameLabel:SetTextColor(Color(255, 255, 255))
        serverNameLabel:SizeToContents()
        serverNameLabel:Center()

        motdFrame = vgui.Create("DFrame")
        motdFrame:SetSize(600, 420)
        motdFrame:SetTitle("")
        motdFrame:SetPos((ScrW() - motdFrame:GetWide()) / 2, ScrH() / 2 - motdFrame:GetTall() / 2)
        motdFrame:SetVisible(true)
        motdFrame:SetDraggable(false)
        motdFrame:ShowCloseButton(false)
        motdFrame:MakePopup()

        local animationTime = 32
        local animStartTime = CurTime()

        motdFrame.Paint = function(self, w, h)
            local animProgress = ((CurTime() - animStartTime) % animationTime) / animationTime
            local startColor = Color(40, 40, 40)
            local endColor = Color(32, 32, 32)
            local loopProgress = math.abs(math.sin(math.pi * animProgress))
            local lerpedColor = LerpColor(loopProgress, startColor, endColor)

            draw.RoundedBoxEx(8, 0, 0, w, 6, Color(52, 152, 219), true, true, true, true)
            draw.RoundedBoxEx(8, 0, 6, w, h - 6, lerpedColor, false, false, true, true)
        end

        local motdMessage = [[
            Welcome to our server!
            
            Rules:
            1. Be respectful to others.
            2. No cheating or exploiting.
            3. Have fun!
        ]]
        local messageLabel = vgui.Create("DLabel", motdFrame)
        messageLabel:SetText("")
        messageLabel:SetFont("DermaLarge")
        messageLabel:SetTextColor(Color(255, 255, 255))
        messageLabel:SetContentAlignment(5)
        messageLabel:SetWrap(true)
        messageLabel:SetAutoStretchVertical(true)
        messageLabel:SetWide(580)
        messageLabel:Dock(FILL)
        messageLabel:DockMargin(10, 10, 10, 10)

        local function simulateTyping(text, label)
            local delay = 0.05
            local index = 1

            timer.Create("TypingEffectTimer", delay, #text, function()
                label:SetText(string.sub(text, 1, index))
                label:SizeToContents()

                index = index + 1
            end)
        end

        simulateTyping(motdMessage, messageLabel)

        local discordButton = vgui.Create("DButton", motdFrame)
        discordButton:SetText("Discord")
        discordButton:SetTextColor(Color(255, 255, 255))
        discordButton:SetFont("DermaDefault")
        discordButton:SetSize(100, 30)
        discordButton:SetPos(50, motdFrame:GetTall() - discordButton:GetTall() - 20)
        discordButton.Paint = function(self, w, h)
            draw.RoundedBox(8, 0, 0, w, h, Color(52, 152, 219))
        end
        discordButton.DoClick = function()
            gui.OpenURL("https://discord.com/")
        end

        local workshopButton = vgui.Create("DButton", motdFrame)
        workshopButton:SetText("Workshop")
        workshopButton:SetTextColor(Color(255, 255, 255))
        workshopButton:SetFont("DermaDefault")
        workshopButton:SetSize(100, 30)
        workshopButton:SetPos(motdFrame:GetWide() - workshopButton:GetWide() - 50, motdFrame:GetTall() - workshopButton:GetTall() - 20)
        workshopButton.Paint = function(self, w, h)
            draw.RoundedBox(8, 0, 0, w, h, Color(52, 152, 219))
        end
        workshopButton.DoClick = function()
            gui.OpenURL("https://steamcommunity.com/workshop/")
        end

        closeButton = vgui.Create("DButton", motdFrame)
        closeButton:SetText("Close(5)")
        closeButton:SetTextColor(Color(255, 255, 255))
        closeButton:SetFont("DermaDefault")
        closeButton:SetSize(80, 30)
        closeButton:SetPos((motdFrame:GetWide() - closeButton:GetWide()) / 2, motdFrame:GetTall() - closeButton:GetTall() - 20)
        closeButton.Paint = function(self, w, h)
            draw.RoundedBox(8, 0, 0, w, h, Color(231, 76, 60))
        end
        closeButton:SetEnabled(false)
        closeButton.DoClick = function()
            serverNameFrame:Close()
            motdFrame:Close()
        end

        -- Disable close button until countdown timer ends
        local delayBeforeClose = 5
        timer.Simple(#motdMessage * 0.05, function()
            timer.Create("CloseButtonCountdown", 1, delayBeforeClose, function()
                delayBeforeClose = delayBeforeClose - 1
                if delayBeforeClose == 0 then
                    closeButton.Paint = function(self, w, h)
                        draw.RoundedBox(8, 0, 0, w, h, Color(46, 204, 113))
                    end
                    closeButton:SetEnabled(true)
                end
                closeButton:SetText("Close(" .. delayBeforeClose .. ")")
            end)
        end)
    end

    local function showMOTD()
        createFrames()
    end

    net.Receive("showMOTD", showMOTD)

    function LerpColor(frac, from, to)
        return Color(
            Lerp(frac, from.r, to.r),
            Lerp(frac, from.g, to.g),
            Lerp(frac, from.b, to.b),
            Lerp(frac, from.a or 255, to.a or 255)
        )
    end
end
