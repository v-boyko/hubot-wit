stringify = require 'json-stringify-safe'
WitListener = require './wit-listener'

module.exports = (robot) ->

  robot.listeners.push new WitListener(
    robot,
    (msg) ->
      message = msg.envelope.message
      outcomes = message.outcomes
      robot.logger.debug "Outcomes: #{outcomes}"
      
      for outcome in outcomes
        do ->
          # do not trigger not confident enough
          return if (outcome.confidence < 0.5)

          event_id = "wit:#{outcome.intent}"
          outcome.user = message.user
          outcome.room = message.room
          outcomeStr = stringify(outcome, null, " ")
          robot.logger.debug " - outcome: #{outcomeStr}"
          try
            robot.emit event_id, new robot.Response(robot, outcome, null)
          catch err
            robot.logger.error err
  )
