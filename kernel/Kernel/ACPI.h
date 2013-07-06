#ifndef __ACPI_H_
#define __ACPI_H_

struct RSDPDescriptor {
 char Signature[8];
 char Checksum;
 char OEMID[6];
 char Revision;
 int RsdtAddress;
 // since ACPI 2.0
 int Length;
 long XsdtAddress;
 char ExtendedChecksum;
 char reserved[3];
};

struct SDTHeader {
  char Signature[4];
  int Length;
  char Revision;
  char Checksum;
  char OEMID[6];
  char OEMTableID[8];
  int OEMRevision;
  int CreatorID;
  int CreatorRevision;
};


extern void ACPI_test();
extern RSDPDescriptor* ACPI_findRSDP();

#endif