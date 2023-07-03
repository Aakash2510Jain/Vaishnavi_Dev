@isTest
public class ParseWhatsappTemplatesTest {
    @isTest
    static void testParseMethod() {
        // Create a JSON string representing the data
        String json = '{ "data": [ { "id": "6580914", "name": "dropped_lead_serene", "category": "MARKETING", "language": "en", "type": "TEXT", "body": "It was a pleasure talking to you! I will be happy to connect with you further and take you through our delightfully designed residential projects that may suit your requirement and is within your expectations.", "button_type": "NONE", "quality_score": "UNKNOWN", "status": "ENABLED", "creation_time": "1670395658772", "updation_time": "1682447978241" } ], "meta": { "total": "24" } }';
        
        // Call the parse method
        ParseWhatsappTemplates result = ParseWhatsappTemplates.parse(json);
        
        // Perform assertions
        System.assertEquals(1, result.data.size());
        System.assertEquals('6580914', result.data[0].id);
        System.assertEquals('dropped_lead_serene', result.data[0].name);
        System.assertEquals('MARKETING', result.data[0].category);
        System.assertEquals('en', result.data[0].language);
        System.assertEquals('TEXT', result.data[0].type);
        System.assertEquals('It was a pleasure talking to you! I will be happy to connect with you further and take you through our delightfully designed residential projects that may suit your requirement and is within your expectations.', result.data[0].body);
        System.assertEquals('NONE', result.data[0].button_type);
        System.assertEquals('UNKNOWN', result.data[0].quality_score);
        System.assertEquals('ENABLED', result.data[0].status);
        System.assertEquals('1670395658772', result.data[0].creation_time);
        System.assertEquals('1682447978241', result.data[0].updation_time);
      //  System.assertEquals('24', result.meta.total);
    }
}