import ballerinax/health.fhir.r4;
import ballerinax/health.fhir.r4.international401;

function getName(r4:HumanName[]? names) returns string {
    if names is () || names.length() == 0 {
        return "";
    }
    r4:HumanName firstNameRecord = names[0];
    string[] givenNames = firstNameRecord?.given ?: [];
    string familyName = firstNameRecord?.family ?: "";
    string fullName = "";
    foreach string given in givenNames {
        fullName = fullName + given + " ";
    }
    fullName = fullName + familyName;
    return fullName.trim();
}

function mapGender(international401:PatientGender? gender) returns string {
    if gender is () {
        return "";
    }
    if gender is international401:CODE_GENDER_MALE {
        return "male";
    }
    if gender is international401:CODE_GENDER_FEMALE {
        return "female";
    }
    if gender is international401:CODE_GENDER_OTHER {
        return "other";
    }
    return "unknown";
}
