--locations
local Impound = {}
Impound[0] = {["x"] = 401.457,["y"] = -1632.219, ["z"] = 29.292}

local MissionData = {
  [0] = {1212.4463, 2667.4351, 38.79},
  [1] = {667.774047851563,645.631591796875,129.117416381836},
  [2] = {951.941589355469,117.730613708496,80.8039398193359},
  [3] = {-470.299102783203,115.67733001709,64.1058731079102},
  [4] = {-722.903442382813,10.4185571670532,38.0618133544922},
  [5] = {-838.86328125,32.8317413330078,45.658748626709},
  [6] = {-764.597351074219,236.763778686523,75.6799621582031},
  [7] = {-261.666046142578,-1049.05944824219,27.0409679412842},
  [8] = {-354.182464599609,-1085.03015136719,23.0259399414063},
  [9] = {-481.656585693359,-962.669555664063,23.5505599975586},
  [10] = {-543.159606933594,-890.435485839844,24.9215240478516},
  [11] = {-531.285949707031,-902.518127441406,23.8615741729736},
  [12] = {-615.102722167969,-803.444519042969,25.5514602661133},
  [13] = {-703.947448730469,-872.18310546875,23.5121688842773},
  [14] = {-723.691955566406,-916.486022949219,19.0138988494873},
  [15] = {-1204.00317382813,-1536.19506835938,4.32140684127808},
  [16] = {-1152.76354980469,-1411.939453125,4.92401218414307},
  [17] = {-1112.17590332031,-1284.49645996094,5.42191886901855},
  [18] = {-1035.81970214844,-1348.37878417969,5.45427989959717},
  [19] = {-926.571166992188,-2926.93725585938,13.945255279541},
  [20] = {-925.467895507813,-2827.01147460938,13.9497509002686},
  [21] = {-991.35107421875,-2749.18872070313,13.7566385269165},
  [22] = {-1004.71331787109,-2751.91625976563,13.7566423416138},
  [23] = {-1021.00451660156,-2368.70239257813,13.9445371627808},
  [24] = {-939.911254882813,-2322.38623046875,6.70908880233765},
  [25] = {-840.335327148438,-2305.14794921875,6.70902919769287}
}

local Keys = {
	["ESC"] = 322, ["F1"] = 288, ["F2"] = 289, ["F3"] = 170, ["F5"] = 166, ["F6"] = 167, ["F7"] = 168, ["F8"] = 169, ["F9"] = 56, ["F10"] = 57,
	["~"] = 243, ["1"] = 157, ["2"] = 158, ["3"] = 160, ["4"] = 164, ["5"] = 165, ["6"] = 159, ["7"] = 161, ["8"] = 162, ["9"] = 163, ["-"] = 84, ["="] = 83, ["BACKSPACE"] = 177,
	["TAB"] = 37, ["Q"] = 44, ["W"] = 32, ["E"] = 38, ["R"] = 45, ["T"] = 245, ["Y"] = 246, ["U"] = 303, ["P"] = 199, ["["] = 39, ["]"] = 40, ["ENTER"] = 18,
	["CAPS"] = 137, ["A"] = 34, ["S"] = 8, ["D"] = 9, ["F"] = 23, ["G"] = 47, ["H"] = 74, ["K"] = 311, ["L"] = 182,
	["LEFTSHIFT"] = 21, ["Z"] = 20, ["X"] = 73, ["C"] = 26, ["V"] = 0, ["B"] = 29, ["N"] = 249, ["M"] = 244, [","] = 82, ["."] = 81,
	["LEFTCTRL"] = 36, ["LEFTALT"] = 19, ["SPACE"] = 22, ["RIGHTCTRL"] = 70,
	["HOME"] = 213, ["PAGEUP"] = 10, ["PAGEDOWN"] = 11, ["DELETE"] = 178,
	["LEFT"] = 174, ["RIGHT"] = 175, ["TOP"] = 27, ["DOWN"] = 173,
	["NENTER"] = 201, ["N4"] = 108, ["N5"] = 60, ["N6"] = 107, ["N+"] = 96, ["N-"] = 97, ["N7"] = 117, ["N8"] = 61, ["N9"] = 118
}

local MISSION = {}
MISSION.start = false
MISSION.vehicle= false
MISSION.truck = false

local currentMission = -1

local playerCoords
local playerPed

showStartText   = false

--text for mission
local text1 = false
local text2 = false

--blips
local BLIP = {}

BLIP.company = 0

BLIP.vehicle = {}
BLIP.vehicle.i = 0

BLIP.destination = {}
BLIP.destination.i = 0


local initload = false
Citizen.CreateThread(function()
    while true do
       Wait(0)
       playerPed = GetPlayerPed(-1)
       playerCoords = GetEntityCoords(playerPed, 0)
        if (not initload) then
            init()
            initload = true
        end
        tick()
    end
end)

function init()
    BLIP.company = AddBlipForCoord(Impound[0]["x"], Impound[0]["y"], Impound[0]["z"])
    SetBlipSprite(BLIP.company, 357)
    SetBlipDisplay(BLIP.company, 4)
    SetBlipScale(BLIP.company, 0.8)

    BeginTextCommandSetBlipName("STRING")
    AddTextComponentString("TowTruck")
    EndTextCommandSetBlipName(BLIP.company)
    Citizen.Trace("Truck Blip added.\n")

    -- Create Tonya
    RequestModel(0xcac85344)
    while not HasModelLoaded(0xcac85344) do
      Wait(1)
    end

    tonya = CreatePed(5, 0xcac85344, 405.158, -1625.421, 29.292, 62.935, false, true)
  	GiveWeaponToPed(tonya, 0x1B06D571, 2800, false, true)
  	SetPedCombatAttributes(tonya, 46, true)
  	SetPedFleeAttributes(tonya, 0, 0)
  	SetPedArmour(tonya, 100)
  	SetPedMaxHealth(tonya, 100)
  	SetPedRelationshipGroupHash(tonya, GetHashKey("PLAYER"))
  	TaskStartScenarioInPlace(tonya, "WORLD_HUMAN_PROSTITUTE_LOW_CLASS", 0, true)
  	SetPedCanRagdoll(tonya, false)
  	SetPedDiesWhenInjured(tonya, false)
    Citizen.Trace("Tonya is added.\n")
end

--Draw Text / Menus
function tick()

    --Show menu, when player is near
    if(MISSION.start == false) then
    if(GetDistanceBetweenCoords( playerCoords, Impound[0]["x"], Impound[0]["y"], Impound[0]["z"] ) < 20) then
            if(showStartText == false) then
               ShowInfo("Press ~INPUT_CONTEXT~ to start", 0)
                StartText()
            end
                --key controlling
                -- Start mission
                if(IsControlPressed(1, Keys["E"])) then
                    spawnTruck()
                    SpawnMission()
                end
                -- End mission
                if(IsControlPressed(1, Keys["DELETE"])) then
                     -- clear()
                end
            else
                showStartText = false
        end --if GetDistanceBetweenCoords ...

    end --if MISSION.start == false
end

function spawnTruck()
  -- Load the towtruck model.
  RequestModel(GetHashKey("towtruck"))
  while not HasModelLoaded(GetHashKey("towtruck")) do
    Wait(1)
  end

 -- Spawn the towtruck model.
    truck = CreateVehicle(GetHashKey("towtruck"), 408.780,-1639.286,29.291, false, false)
    SetVehicleNumberPlateText(truck, "M15510")
    SetVehRadioStation(truck, "OFF")
    SetPedIntoVehicle(playerPed, truck, -1)
end

function SpawnMission()
  showLoadingPromt("Loading tow truck mission", 2000, 3)
  --currently one destination
  RequestModel(GetHashKey("felon"))
  while not HasModelLoaded(GetHashKey("felon")) do
    Wait(1)
  end

  vehicle = CreateVehicle(GetHashKey("felon"), -261.666046142578,-1049.05944824219,27.0409679412842, false, false)
  current = AddBlipForCoord(-261.666046142578,-1049.05944824219,27.0409679412842)
  SetBlipSprite(current, 1)
  SetBlipColour(current, 3)
  SetBlipRoute(current, true)
  -- Start the mission
  MISSION.start = true

  if GetDistanceBetweenCoords(GetEntityCoords(GetPlayerPed(-1)), -261.666, -1049.059, 27.04, true) > 500.00 then
    DrawMissionText("~w~Attach the ~y~vehicle ~w~to the towtruck and bring it back to the ~y~impound~w~.", 900)
    SetBlipRoute(current, true)
  else
    SetBlipRoute(current, false)
  end
end

function StartText()
    DrawMissionText("~w~Help ~y~Tonya~w~, you will get ~g~money~w~ when the job is done.", 900)
end


function drawTxt(x,y ,width,height,scale, text, r,g,b,a)
    SetTextFont(0)
    SetTextProportional(0)
    SetTextScale(scale, scale)
    SetTextColour(r, g, b, a)
    SetTextDropShadow(0, 0, 0, 0,255)
    SetTextEdge(1, 0, 0, 0, 255)
    SetTextDropShadow()
    SetTextOutline()
    SetTextEntry("STRING")
    AddTextComponentString(text)
    DrawText(x - width/2, y - height/2 + 0.005)
end

function DrawMissionText(m_text, showtime)
  ClearPrints()
  SetTextEntry_2("STRING")
  AddTextComponentString(m_text)
  DrawSubtitleTimed(showtime, 1)
end

function ShowInfo(text, state)
	SetTextComponentFormat("STRING")
	AddTextComponentString(text)
	DisplayHelpTextFromStringLabel(0, state, 0, -1)
end

function showLoadingPromt(showText, showTime, showType)
	Citizen.CreateThread(function()
		Citizen.Wait(0)
		N_0xaba17d7ce615adbf("STRING") -- set type
		AddTextComponentString(showText) -- sets the text
		N_0xbd12f8228410d9b4(showType) -- show promt (types = 3)
		Citizen.Wait(showTime) -- show time
		N_0x10d373323e5b9c0d() -- remove promt
	end)
end
