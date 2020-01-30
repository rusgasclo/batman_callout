
local Time       = Game.Time;
local Delay      = 1; -- game seconds
local Ready      = Time() + Delay;
local Find       = this.GetNearbyObjects
local found_target = "not_found"
local Batmob = Find( 'Batmobile', 2 )
this.TargetX = ""
this.Targety = ""

function Create()
    Interface.AddComponent(this,"toggleLeathalityCaption", "Caption","tooltip_button_Leathality_Caption")
    Interface.AddComponent(this,"toggleLeathality", "Button","tooltip_button_Leathality_Pacify")
    Interface.AddComponent(this,"spacerCaption", "Caption","tooltip_spacer_Caption")
    Interface.AddComponent(this,"buttonCancelCallout", "Button","tooltip_button_Cancel_Callout")
end

function Update()
  if Time() > Ready then
    Ready = Time() + Delay
    this.age = this.age + 1
    --Game.DebugOut(this.age)
    if this.age <= this.max_age then
    	if this.Dest.x + this.Dest.y == 0 then
      		Game.DebugOut("finding target")
      		find_target()
      		end
    	if at_destination() == false then
        open_door()
        end
    	if at_destination() and attacking == false then 
        Game.DebugOut("attacking")
        attack_target()
        end
      return
      end
Object.NavigateTo( me, this.HomeX, this.HomeY )	
end
end

function find_target()
    local prisoners = Find( 'Prisoner', 500 )
        for prisonerName, prisonerDistance in pairs(prisoners) do
            Game.DebugOut(prisonerName.Damage)
            if this.no_mercy == true and prisonerName.Damage <= (this.damage_to_deal-0.01) then
              --Game.DebugOut("x" ..prisonerName.Pos.x .. " y" ..prisonerName.Pos.y)
              this.TargetX = prisonerName.Pos.x
              this.TargetY = prisonerName.Pos.y
              Object.NavigateTo( me, this.TargetX, this.TargetY )	
              attacking = false
              return
              end
           if this.no_mercy == false and prisonerName.Damage <= (this.damage_to_deal)-0.01 and (prisonerName.Misbehavior=="Spoiling" or prisonerName.Misbehavior=="Fighting" or prisonerName.Misbehavior=="Rioting" or prisonerName.Misbehavior=="Destroying" or prisonerName.Misbehavior=="Misbehaving" or prisonerName.Misbehavior=="Escaping") then
            --Game.DebugOut("x" ..prisonerName.Pos.x .. " y" ..prisonerName.Pos.y)
            this.TargetX = prisonerName.Pos.x
            this.TargetY = prisonerName.Pos.y
            Object.NavigateTo( me, this.TargetX, this.TargetY )	
            attacking = false
            return
            end
        end
	this.age = this.max_age
    --this.LeaveMap()
end

  function attack_target()
    attacking = true
    local prisoners2 = Find( 'Prisoner', 2 )
          for prisonerName, prisonerDistance in pairs(prisoners2) do
              if prisonerName.Damage < this.damage_to_deal+0.01 then -- check if prisoner is concious
              Object.Sound("_Tools","HitBy_Baton") 
              prisonerName.Damage = this.damage_to_deal
              if this.damage_to_deal >= 0.85 and this.damage_to_deal <1 then
                prisonerName.StatusEffects.wounded = 60
                end
            end     
      end
  end
    
  function at_destination()
    if this.TargetX == nil or this.TargetY == nil then
      return false
      end
     if this.Pos.x - this.TargetX  <= 1 and this.Pos.x - this.TargetX >= -1 and this.Pos.y - this.TargetY <= 1 and this.Pos.y - this.TargetY >= -1 then
       return true
      end
	return false
  end


function open_door()
--Game.DebugOut("looking for door")
    local finddoors = Find( 'JailDoor', 1 )
        for doorName, doorDistance in pairs(finddoors) do
		Game.DebugOut("found door")
		if type(doorName.Open) ~= "number" then
			doorName.Open = 0
			end	
		if doorName.Open <1 then 		
			repeat
			i = doorName.Open
			doorName.Open = i + 0.2
			until i >= 1
			Object.Sound( "JailDoor", "EndClose" )
			end
		end
        finddoors = Find( 'RoadGate', 2 )
        for doorName, doorDistance in pairs(finddoors) do
		Game.DebugOut("found door")
		if type(doorName.Open) ~= "number" then
			doorName.Open = 0
			end	
		if doorName.Open <1 then 		
			repeat
			i = doorName.Open
			doorName.Open = i + 0.2
			until i >= 1
			Object.Sound( "JailDoor", "EndClose" )
			end
		end
            finddoors = Find('StaffDoor', 1 )
        for doorName, doorDistance in pairs(finddoors) do
		Game.DebugOut("found door")
		if type(doorName.Open) ~= "number" then
			doorName.Open = 0
			end	
		if doorName.Open <1 then 		
			repeat
			i = doorName.Open
			doorName.Open = i + 0.2
			until i >= 1
			Object.Sound( "JailDoor", "EndClose" )
			end
		end
    finddoors = Find('JailDoorLarge', 1 )
        for doorName, doorDistance in pairs(finddoors) do
		Game.DebugOut("found door")
		if type(doorName.Open) ~= "number" then
			doorName.Open = 0
			end	
		if doorName.Open <1 then 		
			repeat
			i = doorName.Open
			doorName.Open = i + 0.2
			until i >= 1
			Object.Sound( "JailDoor", "EndClose" )
			end
		end
	end
 function buttonCancelCalloutClicked()
  this.age = this.max_age
  Object.NavigateTo( me, this.HomeX, this.HomeY )	
end  

function toggleLeathalityClicked()
  if this.leathal == 0 then
    this.leathal = 1
    this.SetInterfaceCaption("toggleLeathality","tooltip_button_Leathality_Maim")
      for BName, BDistance in pairs(Batmob) do
      BName.SetInterfaceCaption("toggleLeathality","tooltip_button_Leathality_Maim") 
      Object.SetInterfaceCaption(BName,"toggleLeathality","tooltip_button_Leathality_Maim") 
      end
    this.damage_to_deal = this.damage_maim
    return
    end
  if this.leathal == 1 then
    this.leathal = 2
    this.SetInterfaceCaption("toggleLeathality","tooltip_button_Leathality_Kill")
    for BName, BDistance in pairs(Batmob) do
      BName.SetInterfaceCaption("toggleLeathality","tooltip_button_Leathality_Kill") 
      Object.SetInterfaceCaption(BName,"toggleLeathality","tooltip_button_Leathality_Kill") 
      end
    this.damage_to_deal = this.damage_kill
    return
    end
  if this.leathal == 2 then
    this.leathal = 0
    this.SetInterfaceCaption("toggleLeathality","tooltip_button_Leathality_Pacify")
    for BName, BDistance in pairs(Batmob) do
      BName.SetInterfaceCaption("toggleLeathality","tooltip_button_Leathality_Pacify") 
      Object.SetInterfaceCaption(BName,"toggleLeathality","tooltip_button_Leathality_Pacify") 
      end
    this.damage_to_deal = this.damage_pacify
    return
    end
end