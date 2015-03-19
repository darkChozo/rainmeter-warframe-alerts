-- set up measures, variables
function Initialize()
  alertIdMeasure1 = SKIN:GetMeasure("MeasureAlertId1")
  alertAuthorMeasure1 = SKIN:GetMeasure("MeasureAlertAuthor1")
  alertIdMeasure2 = SKIN:GetMeasure("MeasureAlertId2")
  alertAuthorMeasure2 = SKIN:GetMeasure("MeasureAlertAuthor2")
  alertIdMeasure3 = SKIN:GetMeasure("MeasureAlertId3")
  alertAuthorMeasure3 = SKIN:GetMeasure("MeasureAlertAuthor3")
  alertIdMeasure4 = SKIN:GetMeasure("MeasureAlertId4")
  alertAuthorMeasure4 = SKIN:GetMeasure("MeasureAlertAuthor4")
  alertNotification = SELF:GetOption("NotificationSound")
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
  if alertAuthorMeasure1:GetStringValue() == "Alert" and alertIdMeasure1:GetStringValue() ~= '' then
    alerts[1] = alertIdMeasure1:GetStringValue()
  end
  if alertAuthorMeasure2:GetStringValue() == "Alert" and alertIdMeasure2:GetStringValue() ~= '' then
    alerts[2] = alertIdMeasure2:GetStringValue()
  end
  if alertAuthorMeasure3:GetStringValue() == "Alert" and alertIdMeasure3:GetStringValue() ~= '' then
    alerts[3] = alertIdMeasure3:GetStringValue()
  end
  if alertAuthorMeasure4:GetStringValue() == "Alert" and alertIdMeasure4:GetStringValue() ~= '' then
    alerts[4] = alertIdMeasure4:GetStringValue()
  end
  -- check if any alerts are new
  for i, alert in ipairs(alerts) do
    if alerts ~= '-1' then
	  local isNewAlert = true
      for i, oldAlert in ipairs(oldAlerts) do
	    if alert == oldAlert then isNewAlert = false end
	  end
	  if isNewAlert then newAlert = true end
	end
  end
  if SKIN:GetVariable('EnableNotificationSound') == 'true' and newAlert then
    SKIN:Bang('Play ' .. alertNotification)
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