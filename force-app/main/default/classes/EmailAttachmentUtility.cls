public with sharing class EmailAttachmentUtility {

    public static Map<String,Messaging.InboundEmailHandler> messageIDToEmail_Map;

    @InvocableMethod(label='Save Inbound Email Attachments' description='Saves attachments for inbound emails to a specified record ID. Only works when email comes from an inbound email handler' category='Inbound Emails')
    public static List<Boolean> saveAttachmentsToRecord_Invocable(List<Request> emails) {

        List<Boolean> successes = new List<Boolean>();

        for(Request req:emails) {
            Boolean success = false;
            if(EmailMapSingleton.containsKey(req.messageId)) {
                success = EmailAttachmentUtility.saveAttachmentsToRecord(
                    req.recordId,
                    emailMapSingleton.get(req.messageId)
                );
            }
            successes.add(success);
        }

        return successes;
    }

    public class Request {
        @InvocableVariable(label='Email Message ID' description='Allows apex to find the attachments' required=true)
        public String messageId;
        @InvocableVariable(label='Related Record ID' description='The record which the email attachments will be related to' required=true)
        public String recordId;
    }

    public static Boolean saveAttachmentsToRecord(String recordID, Messaging.InboundEmail email) {

        Boolean success = false;

        if (email.binaryAttachments != null && email.binaryAttachments.size() > 0) {

            for (Messaging.InboundEmail.binaryAttachment att :email.binaryAttachments) {
                // TODO: bulkify
                ContentVersion cv = new ContentVersion();
                cv.VersionData = att.body;
                cv.Title = att.fileName;
                cv.PathOnClient = att.fileName;

                cv = [
                    SELECT  ContentDocumentId 
                    FROM    ContentVersion 
                    WHERE   Id =:cv.Id 
                    LIMIT   1
                ];
    
                ContentDocumentLink cdl = new ContentDocumentLink();
                cdl.LinkedEntityId = recordID;
                cdl.ContentDocumentId = cv.ContentDocumentId;
                cdl.ShareType = 'V';
                insert cdl;

                success = true;
            }
        }

        return success;
    }
}
