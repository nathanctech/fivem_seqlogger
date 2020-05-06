# fivem_seqlogger
Seq support for FiveM.

Seq is a centralized logging tool that supports many different languages and logging schemes. This resource utitlizes the "raw" JSON endpoint to pass events.

**NOTE**: Seq is a non-free tool past one user. See their pricing page for detailed information.

## Installation

1) Seq (https://datalust.co/seq) is required for this resource to work. Configuration is up to you and is outside the scope of this readme.

2) Unzip the resource.

3) Add the following configuration to your server.cfg:

```
# set the URL to the raw event handler, example below
set seq.url "http://localhost:5341/api/events/raw?clef"

# Seq API key
set seq.apikey ""

# Enables the resource
set seq.enabled "true"

# Debug mode, which adds prints for every event sent.
set seq.debug "false"

# Set to true to allow clients to fire log events. This can be a potential DoS risk, so it's disabled by default.

set seq.clientevents "false"

# Turns version checking on or off.
set seq.versioncheck true
```

## Usage

By default, the resource will send console messages to Seq as debug messages. This code can be found in `sv_console.lua`.

The easiest way to log stuff to Seq is to call an event. The syntax is as follows:

```lua
TriggerEvent("Seq:Log", eventSource, eventId, message, severity, extras)
```

### Fields

```
eventSource: The source of the event, can be whatever you wish for filtering purposes.
eventId: A random ID if passed nil, otherwise a unique key for your event.
Message: the message displayed on Seq without clicking on the event.
Severity: Severity of the message, can be customized in Seq. Defaults are: Debug, Notice, Warning, Error.
Extras: A table of key/value pairs with additional data. This data appears when a user clicks on the event to see details and is searchable.
```

### Example

The following example logs connecting clients:

```lua
AddEventHandler("playerConnecting", function(player, disconnectReason)
    local source = source
    local data = {}

    -- details for the extras
    data["event"] = "connect"
    data["user_name"] = player

    -- event trigger
    TriggerEvent("Seq:Log", "logging", nil, ("Player Connect: [%s] %s"):format(source, player), "Notice", data)
end)
```

You can add as many "extras" to the record as you want.


## Support

Support is provided on a best-effort basis. The contributors do not guarantee any kind of support for this resource. Please open an issue if you have a problem with the code.
