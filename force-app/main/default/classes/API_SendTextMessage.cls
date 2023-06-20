public class API_SendTextMessage {
    public static void sendMessage(string recipientNumber, string message){
        system.debug('message-->'+message);
        message = EncodingUtil.URLENCODE(message,'UTF-8').replace('+', '%20');
        system.debug('message--->'+message);
    }
}