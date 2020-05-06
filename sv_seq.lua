--[[
seq_logger, created by Nathan C (Era#1337)

Version: 1.0

seq_logger is a logging framework that can send events to Seq (https://datalust.co/seq),
a powerful logging aggregation tool.

PLEASE READ README.md AND IMPORTANT CONFIGURATION BEFORE USING.

MIT License

Copyright (c) 2020 Nathan C

Permission is hereby granted, free of charge, to any person obtaining a copy
of this software and associated documentation files (the "Software"), to deal
in the Software without restriction, including without limitation the rights
to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
copies of the Software, and to permit persons to whom the Software is
furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all
copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
SOFTWARE.

]]

-- DO NOT EDIT ANYTHING BELOW UNLESS YOU KNOW WHAT ARE DOING

-- Want to contribute? Fork me: (https://github.com/nathanctech/fivem_seqlogger)

local SeqUrl = GetConvar("seq.url","http://localhost:5341/api/events/raw?clef")
local apiKey = GetConvar("seq.apikey","")
local isEnabled = GetConvar("seq.enable", "false")
local debugMode = GetConvar("seq.debug", "false")
local allowClientEvents = GetConvar("seq.clientevents", "false")

function debugPrint(message)
    if debugMode == "true" then
        print("[seq_logger] "..message)
    end
end

function sendEvent(event)
    if not isEnabled then
        debugPrint("isEnabled is false. Ignoring event.")
        return
    end
    if apiKey == nil or SeqUrl == nil then
        print("SEQ LOGGER ERROR: You did not configure an API key!")
        return
    end
    local headers = {["X-Seq-ApiKey"] = apiKey, ["Content-Type"] = "application/json"}
    debugPrint("Will send: "..json.encode(event))
    PerformHttpRequest(SeqUrl, function(errorCode, result, headers)    
         debugPrint("sendEvent Response: "..tostring(result).." "..tostring(errorCode))
    end, "POST", json.encode(event) or "", headers)
end

function handleEvent(eventSource, eventId, message, severity, extras)
    local payload = {}
    if extras ~= nil then
        for k, v in pairs(extras) do
            if k == "exception" then
                payload["@x"] = v
            else
                payload[k] = v
            end
        end
    end
    payload["@t"] = os.date("!%Y-%m-%dT%H:%M:%SZ")
    payload["@u"] = eventId
    payload["@m"] = message
    payload["@l"] = severity
    payload["EventSource"] = eventSource
    sendEvent(payload)

end

-- exported wrapper
function SeqLog(eventSource, eventId, message, severity, extras)
    if eventId == nil then
        eventId = randomId()
    end
    handleEvent(eventSource, eventId, message, severity, extras)
end
exports("SeqLog",SeqLog)

-- or an event
RegisterNetEvent("Seq:Log")
AddEventHandler("Seq:Log", function(eventSource, eventId, message, severity, extras)
    if source ~= nil and source ~= 0 and not allowClientEvents then
        debugPrint("Disallowing client log event from "..tostring(source))
        return
    end
    if eventId == nil then
        eventId = randomId()
    end
    handleEvent(eventSource, eventId, message, severity, extras)
end)

local charset = {}
for i = 48,  57 do table.insert(charset, string.char(i)) end -- 0 1 2 3 4 5 6 7 8 9
for i = 97, 102 do table.insert(charset, string.char(i)) end -- a b c d e f 

function randomId()
    local id = ""
    for i = 1, 5 do
        id = id .. charset[math.random(1, #charset)]
    end
    return id
end