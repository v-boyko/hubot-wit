{inspect} = require 'util'

{Listener} = require 'hubot/src/listener'
{CatchAllMessage, TextMessage} = require 'hubot/src/message'

wit = require 'node-wit'
promise = require "./promises"

config =
  access_token: process.env.HUBOT_WIT_TOKEN

class WitListener extends Listener

  constructor: (@robot, @callback) ->
    @matcher = (msg) =>
      match = promise()
      # receive all text messages that weren't handled by other listeners
      if msg instanceof CatchAllMessage and msg.message instanceof TextMessage
        wit.captureTextIntent config.access_token, msg.message.text, {verbose: true}, (err, res) ->
          return match.reject err if err
          match.resolve res
      else
        match.reject 'Message is not text message'
      return match

  call: (message) ->
    match = @matcher message
    match.done (result) =>
      result.user = message.message.user
      result.room = message.message.room
      @callback new @robot.Response(@robot, result, null)
    match.fail (err) =>
      @robot.logger.debug "Message '#{message}' is not matched"

module.exports = WitListener
