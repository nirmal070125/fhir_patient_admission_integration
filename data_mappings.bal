import ballerinax/health.fhir.r4.international401;

function transform(international401:Patient fhirPatient) returns MyPatient => {
    gender: mapGender(fhirPatient.gender),
    name: getName(fhirPatient.name),
    dateOfBirth: fhirPatient.birthDate ?: "",
    id: fhirPatient.id ?: ""
};
