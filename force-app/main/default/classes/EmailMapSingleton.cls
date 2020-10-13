public with sharing class EmailMapSingleton {

    private static Map<String,Messaging.InboundEmail> messageIDToEmail_Map;

    public static Messaging.InboundEmail get(String messageId) {
        Messaging.InboundEmail email;
        if(messageIDToEmail_Map == null) {
            messageIDToEmail_Map = new Map<String,Messaging.InboundEmail>();
        }
        if(messageIDToEmail_Map.containsKey(messageId)) {
            email = messageIDToEmail_Map.get(messageId);
        }
        return email;
    }

    public static void put(String messageId, Messaging.InboundEmail email) {
        if(messageIDToEmail_Map == null) {
            messageIDToEmail_Map = new Map<String,Messaging.InboundEmail>();
        }
        messageIDToEmail_Map.put(messageId,email);
    }

    public static Boolean containsKey(String messageId) {
        if(messageIDToEmail_Map == null) {
            messageIDToEmail_Map = new Map<String,Messaging.InboundEmail>();
        }
        return messageIDToEmail_Map.containsKey(messageId);
    }
}
