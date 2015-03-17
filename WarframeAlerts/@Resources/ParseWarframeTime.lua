function Initialize()
  endTimeMeasure = SELF:GetOption("EndTimeMeasure")
end

-- Get end time of alert and return like 1h11m11s or 4d20m
function Update()
  -- end time format is "Tue, 17 Mar 2015 23:16:05 +0000"
  local endTimeMeasure = SKIN:GetMeasure(endTimeMeasure)
  if endTimeMeasure == nil then return '' end
  local endTime = endTimeMeasure:GetStringValue()
  if endTime == nil or endTime == '' then return '' end
  p="%a+, (%d+) (%a+) (%d+) (%d+):(%d+):(%d+)"
  day,month,year,hour,min,sec=endTime:match(p)
  MON={Jan=1,Feb=2,Mar=3,Apr=4,May=5,Jun=6,Jul=7,Aug=8,Sep=9,Oct=10,Nov=11,Dec=12}
  month=MON[month]
  timeLeft = time({day=day,month=month,year=year,hour=hour,min=min,sec=sec}) - os.time()

  if timeLeft < 0 then return 'EXP' end
  if timeLeft < 60 then return timeLeft .. 's' end
  secLeft = timeLeft % 60
  minLeft = math.floor(timeLeft / 60)
  if minLeft < 60 then
    return minLeft .. 'm' .. secLeft .. 's'
  else
    hoursLeft = math.floor(minLeft / 60)
	if hoursLeft < 24 then
	  return hoursLeft .. 'h' .. minLeft % 60 .. 'm' .. secLeft .. 's'
	else
	  daysLeft = math.floor(hoursLeft/24)
	  return daysLeft .. 'd' .. hoursLeft % 24 .. 'h'
	end
  end
end

-- transform UTC time array to Unix current time
function time(t)
  local t_secs = os.time(t) 
  t = os.date("*t", t_secs) 
  local t_UTC = os.date("!*t", t_secs)
  t_UTC.isdst = t.isdst
  local UTC_secs = os.time(t_UTC)

  -- The answer is our original answer plus the difference.
  return t_secs + os.difftime(t_secs, UTC_secs)
end