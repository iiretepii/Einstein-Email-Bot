public class EmailObject {

    @AuraEnabled
    public String subject;
    @AuraEnabled
    public String textBody;
    @AuraEnabled
    public String htmlBody;
    @AuraEnabled
    public String fromAddress;
    @AuraEnabled
    public List<String> toAddresses;
    @AuraEnabled
    public String messageId;

    public EmailObject(Messaging.InboundEmail email) {
        // map email fields
        this.subject = email.subject;
        this.textBody = email.plainTextBody;
        this.htmlBody = email.htmlBody;
        this.fromAddress = email.fromAddress;
        this.toAddresses = email.toAddresses;
        this.messageId = email.messageId;
        EmailMapSingleton.put(this.messageId, email);
    }
}