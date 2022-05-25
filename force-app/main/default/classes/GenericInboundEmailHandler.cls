global with sharing class GenericInboundEmailHandler implements Messaging.InboundEmailHandler {
    global Messaging.InboundEmailResult handleInboundEmail(
        Messaging.InboundEmail email,
        Messaging.InboundEnvelope envelope
    ) {
        EmailObject eo = new EmailObject(email);
        Map<String, Object> myMap = new Map<String, Object>();
        // myMap.put('Received_Email', (Object)eo);
        Flow.Interview.Email_Handler_Flow myFlow = new Flow.Interview.Email_Handler_Flow(myMap);
        System.debug('Flow has STARTED');
        try {
            myFlow.start();
        } catch (Exception e) {
            System.debug(
                'Error with the flow: ' 
                + e.getCause() 
                + '\n' 
                + e.getStackTraceString()
            );
        }
        System.debug('Flow has COMPLETED');
        // boiler plate
        Messaging.InboundEmailResult result = new Messaging.InboundEmailresult();
        result.success = true;
        return result;
    }
}