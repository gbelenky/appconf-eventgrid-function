// Default URL for triggering event grid function in the local environment.
// http://localhost:7071/runtime/webhooks/EventGrid?functionName={functionname}
using System;
using Microsoft.Azure.Functions.Worker;
using Microsoft.Extensions.Logging;

namespace GBelenky.EventTrigger
{
    public class EventGridTrigger
    {
        private readonly ILogger _logger;

        public EventGridTrigger(ILoggerFactory loggerFactory)
        {
            _logger = loggerFactory.CreateLogger<EventGridTrigger>();
        }

        [Function("EventGridTrigger")]
        public void Run([EventGridTrigger] MyEvent input)
        {
            _logger.LogInformation($"Changing the code: {input.Data.ToString()}");
        }
    }

    public class MyEvent
    {
        public string Id { get; set; }

        public string Topic { get; set; }

        public string Subject { get; set; }

        public string EventType { get; set; }

        public DateTime EventTime { get; set; }

        public object Data { get; set; }
    }
}
