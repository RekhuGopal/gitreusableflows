import logging
LOGGER = logging.getLogger()
LOGGER.setLevel(logging.INFO)
def handler(event, context):
    LOGGER.info(f'Event Object: {event}')
    LOGGER.info(f'Context Object: {context}')
    event['DemoChannel'] = 'CloudQuickPOCs'
    return event