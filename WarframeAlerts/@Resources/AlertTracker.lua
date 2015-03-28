-- set up measures, variables
function Initialize()
  audioFilter = {}
  if(SKIN:GetVariable('OnlyNotifyOnPotatos') == 'true') then
    table.insert(audioFilter, "Orokin Reactor")
    table.insert(audioFilter, "Orokin Catalyst")
  end
  if(SKIN:GetVariable('OnlyNotifyOnVauban') == 'true') then
    table.insert(audioFilter, "Vauban Helmet (Blueprint)")
    table.insert(audioFilter, "Vauban Chassis (Blueprint)")
    table.insert(audioFilter, "Vauban Systems (Blueprint)")
  end
  local filterString = ''
  for i,filter in ipairs(audioFilter) do
    filterString = filterString..' "'..filter..'"'
  end
  print("WarframeAlerts: Notifying on the following alerts: "..filterString)
  oldAlerts = {'-1', '-1', '-1', '-1'}
  alerts = {'-1', '-1', '-1', '-1'}
  updateMeters()
end

-- determine whether there's been a new alert and play a notification sound if there is
function Update()
  local newAlert = false
  oldAlerts = alerts
  alerts = {'-1', '-1', '-1', '-1'}
  -- update ids of valid alerts
  for i=1,4 do
    idMeasure = SKIN:GetMeasure("MeasureAlertId"..i)
	authorMeasure = SKIN:GetMeasure("MeasureAlertAuthor"..i)
	if authorMeasure:GetStringValue() == "Alert" and idMeasure:GetStringValue() ~= '' then
      alerts[i] = idMeasure:GetStringValue()
    end
	local validNewAlert
	-- check if should play notification sound
	if audioFilter[1] == nil then validNewAlert = true  -- check if any filters in awkward lua fashion
	else
	  local title = SKIN:GetMeasure("MeasureAlert"..i):GetStringValue()
	  for j,filter in ipairs(audioFilter) do
	    if string.find(title, filter, 1, true) ~= nil then validNewAlert = true end
	  end
	end
    if validNewAlert == true then
	  -- is this a new alert?
	  local isNewAlert = true
      for j,oldAlert in ipairs(oldAlerts) do
	    if alerts[i] == oldAlert then isNewAlert = false end
      end
	  if isNewAlert then newAlert = true end
	end
  end
  if SKIN:GetVariable('EnableNotificationSound') == 'true' and newAlert then
    SKIN:Bang('Play #@#' .. SKIN:GetVariable("NotificationSound"))
	print("New Alert! (sound)")
  elseif newAlert then
    print("New Alert! (no sound)")
  end
  updateMeters()
end

function updateMeters()
  if SKIN:GetVariable('EnableNotificationSound') ~= 'true' then
    SKIN:Bang('!ShowMeter meterSoundOff') 
    SKIN:Bang('!HideMeter meterSoundOn') 
  else
    SKIN:Bang('!ShowMeter meterSoundOn') 
    SKIN:Bang('!HideMeter meterSoundOff') 
  end
end