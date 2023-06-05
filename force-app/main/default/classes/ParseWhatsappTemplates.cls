public class ParseWhatsappTemplates {
    public cls_data[] data;
    public cls_meta meta;
    public class cls_data {
        public string id;	//6580914
        public String name;	//dropped_lead_serene
        public String category;	//MARKETING
        public String language;	//en
        public String type;	//TEXT
        public String body;	//It was a pleasure talking to you! I will be happy to connect with you further and take you through our delightfully designed residential projects that may suit your requirement and is within your expectations.
        public String button_type;	//NONE
        public String quality_score;	//UNKNOWN
        public String status;	//ENABLED
        public string creation_time;	//1670395658772
        public string updation_time;	//1682447978241
    }
    class cls_meta {
        public string total;	//24
    }
    public static ParseWhatsappTemplates parse(String json){
        return (ParseWhatsappTemplates) System.JSON.deserialize(json, ParseWhatsappTemplates.class);
    }
}