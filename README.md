# amazon-sqs-example
This is a very simple example of posting a message to Amazon SQS without the Amazon SDK, using signature version 2.  I made this to better understand how authentication works with Amazon SQS in order to replicate this functionality in Salesforce(using Apex).  I hope it will be useful to others since the only other examples I could find used other Amazon APIs and were far too abstracted.

## How to use

Simply instantiate the Sqs class.

```ruby
message_sender = Sqs.new <access_key_id>, <secret_access_key>, <endpoint>
```

The endpoint is the URL to your queue.

Then just send a message...

```ruby
message_sender.send_message "whutup"
```

My example doesn't support spaces or sending key value pairs, but it should point you in the right direction in terms of authenticating.

## Things to keep in mind

The query parameters must be in alphabetical order(so that the generated signature is consistent), with the exception of the signature key which is placed at the end of the parameters.

