
local Time       = Game.Time;
local Delay      = 1; -- game seconds
local Ready      = Time() + Delay;
local Find       = this.GetNearbyObjects
local max_age = 180
local damage_pacify = 0.71
local damage_maim = 0.85
local damage_kill = 1
local no_mercy = true
      
function Create()
      this.age = 0
      i = 0
      local alreadycalled = Find( 'Batmobile', 500 )
      for BName, BDistance in pairs(alreadycalled) do
        i = i +1
        if i > 1 then
                Game.DebugOut("already called")
                this.Delete()
              end
        end
end

function Update()
  if Time() > Ready then
	Ready = Time() + Delay
	this.age = this.age + 1
    if this.status == null then
      func_arriving()
    end
    if this.status ~= "Waiting" and this.status ~= "Leaving" then
      func_at_dest()
    end
    if this.status == "Waiting" and BatmanS.age >= BatmanS.max_age then
      Game.DebugOut("despawn")
      func_bat_leave()
      end
  end
end

function func_arriving()
  	    local prisoners = Find( 'Prisoner', 500 )
        for prisonerName, prisonerDistance in pairs(prisoners) do
                Game.DebugOut(prisonerName.Damage)
                if prisonerName.Damage < 1 then
                  this.TargetX = this.Pos.x
                  this.TargetY = prisonerName.Pos.y
                  this.NavigateTo(this.TargetX,this.TargetY)
                  this.status = "Arriving"
                  this.Tooltip = this.status
                  return  
                  end
  end
  this.Delete()
end

function func_at_dest()
if this.Pos.x - this.TargetX  <= 1 and this.Pos.x - this.TargetX >= -1 and this.Pos.y - this.TargetY <= 1 and this.Pos.y - this.TargetY >= -1 then
    this.status = "Waiting"
    this.Tooltip = this.status
    local BatmanS = Find('Batman',20)
 --[[   for BatmanSname, BatmanSdistance in pairs(BatmanS) do
        this.HomeX = this.Pos.x
        this.HomeY = this.Pos.y
        this.age = 0
        this.max_age = max_age
        this.damage_to_deal = damage_pacify
        this.leathal = 0
        this.damage_pacify = damage_pacify
        this.damage_maim = damage_maim
        this.damage_kill = damage_kill
        this.no_mercy = no_mercy  ]]  
    --BatmanS = Object.Spawn("Batman", this.Pos.x, this.Pos.y)
    BatmanS.HomeX = this.Pos.x
    BatmanS.HomeY = this.Pos.y
    BatmanS.age = 0
    BatmanS.max_age = max_age
    BatmanS.damage_to_deal = damage_pacify
    BatmanS.leathal = 0
    BatmanS.damage_pacify = damage_pacify
    BatmanS.damage_maim = damage_maim
    BatmanS.damage_kill = damage_kill
    BatmanS.no_mercy = no_mercy
    Interface.AddComponent(this,"toggleLeathalityCaption", "Caption","tooltip_button_Leathality_Caption")
    Interface.AddComponent(this,"toggleLeathality", "Button","tooltip_button_Leathality_Pacify")
    Interface.AddComponent(this,"spacerCaption", "Caption","tooltip_spacer_Caption")
    Interface.AddComponent(this,"buttonCancelCallout", "Button","tooltip_button_Cancel_Callout")
  end
end
       
function func_bat_leave()
if this.Pos.x - BatmanS.Pos.x  <= 1 and this.Pos.x - BatmanS.Pos.x >= -1 and this.Pos.y - BatmanS.Pos.y <= 1 and this.Pos.y - BatmanS.Pos.y >= -1 then
    BatmanS.Delete()
    this.LeaveMap()
    this.status = "Leaving"
    this.Tooltip = this.status
  end
end

function toggleLeathalityClicked()
  if BatmanS.leathal == 0 then
    BatmanS.leathal = 1
    this.SetInterfaceCaption("toggleLeathality","tooltip_button_Leathality_Maim")
    BatmanS.SetInterfaceCaption("toggleLeathality","tooltip_button_Leathality_Maim")
    BatmanS.damage_to_deal = damage_maim
    return
    end
  if BatmanS.leathal == 1 then
    BatmanS.leathal = 2
    BatmanS.SetInterfaceCaption("toggleLeathality","tooltip_button_Leathality_Kill")
    this.SetInterfaceCaption("toggleLeathality","tooltip_button_Leathality_Kill")
    BatmanS.damage_to_deal = damage_kill
    return
    end
  if BatmanS.leathal == 2 then
    BatmanS.leathal = 0
    BatmanS.SetInterfaceCaption("toggleLeathality","tooltip_button_Leathality_Pacify") 
    this.SetInterfaceCaption("toggleLeathality","tooltip_button_Leathality_Pacify") 
    BatmanS.damage_to_deal = damage_pacify
    return
    end
end

function buttonCancelCalloutClicked()
  BatmanS.age = BatmanS.max_age
  Object.NavigateTo( BatmanS, BatmanS.HomeX, BatmanS.HomeY )	
  end

