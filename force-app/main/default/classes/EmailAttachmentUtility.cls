public with sharing class EmailAttachmentUtility {

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

            List<ContentVersion> contentVersions = new List<ContentVersion>();
 
            for (Messaging.InboundEmail.binaryAttachment att :email.binaryAttachments) {
                ContentVersion cv = new ContentVersion();
                cv.VersionData = att.body;
                cv.Title = att.fileName;
                cv.PathOnClient = att.fileName;
                contentVersions.add(cv);
            }

            if(!contentVersions.isEmpty()) {

                insert contentVersions;

                /*
                Set<Id> contentVersionIds = new Set<Id>();
                for(ContentVersion cv:contentVersions) {
                    contentVersionIds.add(cv.Id);
                }
                */

                List<ContentDocumentLink> contentDocumentLinks = new List<ContentDocumentLink>();

                for(ContentVersion cv:[
                    SELECT  ContentDocumentId 
                    FROM    ContentVersion 
                    WHERE   Id IN:contentVersions
                ]) {
                    contentDocumentLinks.add(new ContentDocumentLink(
                        LinkedEntityId = recordID,
                        ContentDocumentId = cv.ContentDocumentId,
                        ShareType = 'V'
                    ));
                }
                insert contentDocumentLinks;
                success = true;
            }
        }

        return success;
    }
}
