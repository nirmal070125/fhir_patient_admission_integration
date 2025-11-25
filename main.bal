import ballerina/io;
import ballerinax/health.fhir.r4;
import ballerinax/health.fhir.r4.international401;
import ballerinax/health.fhir.r4.parser as r4parser;
import ballerinax/health.hl7v2;
import ballerinax/health.hl7v23.utils.v2tofhirr4;

string message_a01 = string `MSH|^~\&|FICTIONAL_ADT_APP|FICTIONAL_HOSPITAL|FICTIONAL_ADT_RECEIVER|FICTIONAL_HOSPITAL|20231027103000||ADT^A01^ADT_A01|MSG00001|P|2.3|||AL|NE|USA|UNICODE UTF-8|||
PID|1||12345678^MRN^FICTIONAL_HOSPITAL^PI||SMITH^JOHN^ROBERT^^MR||19800515|M||2106-3^White^HL70005|123 MAIN ST^^ANYTOWN^GA^30303^USA^H||(555)123-4567|||M^Married^HL70002||ACC00001|||2186-5^Not Hispanic or Latino^HL70005|||||||||
PV1|1|I|200A^200^B1^FICTIONAL_HOSPITAL|E|||12345^DOE^JANE^A^DR|||MED^Medical^HL70069||||E|||12345^DOE^JANE^A^DR||VISIT00001|MC^Managed Care^HL70064|||||||||||||||O|||20231027090000||||||`;

public function main() returns error? {

    // parse the hl7v2 ADT^A01 message. Note that all the HL7v2 messages are prebuilt `ballerinax/health.hl7v2`. 
    hl7v2:Message|error adtA01 = hl7v2:parse(message_a01);
    if adtA01 is error {
        io:println(string `Error occurred while parsing the received message: `, adtA01);
        return;
    }
    // transform the HL7v2 message to FHIR R4 bundle using the prebuilt data mappings.
    json v2tofhirResult = check v2tofhirr4:v2ToFhir(adtA01);

    // parse the FHIR bundle json to Ballerina FHIR R4 bundle record for further processing.
    r4:Bundle bundle = <r4:Bundle>check r4parser:parse(v2tofhirResult);

    // access individual resources from the bundle and modify before sending to FHIR repository.
    r4:BundleEntry[] entries = <r4:BundleEntry[]>bundle.entry;

    foreach var entry in entries {
        map<anydata> fhirResource = <map<anydata>>entry?.'resource;
        // io:println(fhirResource);
        if fhirResource["resourceType"].toString() == "Encounter" {
            international401:Encounter encounterResource = <international401:Encounter>check r4parser:parse(fhirResource.toJson());
            io:println(string `[Encounter] resource json: ${encounterResource.toJson().toString()}`);
        } else if fhirResource["resourceType"].toString() == "Patient" {
            international401:Patient patientResource = <international401:Patient>check r4parser:parse(fhirResource.toJson());
            io:println(string `[Patient] resource json: ${patientResource.toJson().toString()}`);
            MyPatient myPatient = transform(patientResource);
            io:println(string `Custom Patient: ${myPatient.toString()}`);
        } else {
            io:println(`Unsupported resource type: ${fhirResource["resourceType"].toString()}`);
        }
    }
    io:println("[Done] FHIR Bundle is processed successfully");

}
