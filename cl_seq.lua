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

-- exported wrapper
function SeqLog(eventSource, eventId, message, severity, extras)
    if eventId == nil then
        eventId = randomId()
    end
    TriggerServerEvent("Seq:Log", eventSource, eventId, message, severity, extras)
end
exports("SeqLog",SeqLog)

-- or an event
AddEventHandler("Seq:Log", function(eventSource, eventId, message, severity, extras)
    if eventId == nil then
        eventId = randomId()
    end
    TriggerServerEvent("Seq:Log", eventSource, eventId, message, severity, extras)
end)