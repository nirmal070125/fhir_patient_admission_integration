# FHIR Patient Admission Integration

This Ballerina project demonstrates the transformation of HL7v2 ADT^A01 (Patient Admission) messages to FHIR R4 resources with custom data mapping capabilities.

## Overview

The integration performs the following operations:
1. Parses HL7v2 ADT^A01 messages
2. Transforms HL7v2 messages to FHIR R4 Bundle using prebuilt mappings
3. Extracts and processes individual FHIR resources (Patient, Encounter)
4. Applies custom data mappings to transform FHIR Patient resources to a custom format

## Project Structure

```
├── main.bal              # Main entry point with HL7v2 to FHIR transformation logic
├── data_mappings.bal     # Custom transformation function for FHIR Patient to MyPatient
├── functions.bal         # Helper functions for data mapping (getName, mapGender)
├── types.bal             # Custom type definitions (MyPatient record)
├── config.bal            # Configuration variables (empty)
├── connections.bal       # Client connections (empty)
├── agents.bal            # Agent definitions (empty)
└── automation.bal        # Automation logic (empty)
```

## Dependencies

- `ballerinax/health.hl7v2` - HL7v2 message parsing
- `ballerinax/health.hl7v23.utils.v2tofhirr4` - HL7v2 to FHIR R4 transformation utilities
- `ballerinax/health.fhir.r4` - FHIR R4 base types
- `ballerinax/health.fhir.r4.international401` - FHIR R4 international profile
- `ballerinax/health.fhir.r4.parser` - FHIR R4 JSON parser

## Usage

Run the integration:

```bash
bal run
```

## Sample Output

The application processes a sample HL7v2 ADT^A01 message and outputs:
- Encounter resource JSON
- Patient resource JSON
- Custom transformed Patient record

## Custom Data Mapping

The `transform` function maps FHIR Patient resources to a simplified `MyPatient` record with the following fields:
- `id` - Patient identifier
- `name` - Full name (given names + family name)
- `dateOfBirth` - Birth date
- `gender` - Mapped gender value (male/female/other/unknown)

## License

Copyright (c) 2025, WSO2 LLC. (http://www.wso2.com)

