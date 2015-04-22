# hubot-wit

Extension for Hubot to make it understand commands in natural language using Wit.ai.

This extension sends all not catched text-based messages to the Wit.Ai for recognition

# Configuration

Set HUBOT_WIT_TOKEN to match your Wit.Ai instance Authentication Token

# Enabling the extension

Add ```"hubot-auth"``` to your external-scripts.coffee file

# Usage example:

```

module.exports = (robot) ->

  robot.on "wit:my_intent", (msg) ->
    outcome = msg.envelope.message
	msg.send JSON.stringify(outcome, null, 4)

```