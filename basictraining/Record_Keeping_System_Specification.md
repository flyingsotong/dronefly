# Record Keeping System Specification
## Dronefly.sg UABTO

**Document Version:** 1.0  
**Date:** August 2025  
**Prepared by:** Alan Soon, Accountable Manager  

---

## 1. Overview

This document specifies the comprehensive record keeping system for Dronefly.sg UABTO in compliance with CAAS AC 101-3-1(4) requirements. The system ensures proper documentation, storage, retrieval, and disposal of all training-related records.

## 2. Records to be Retained

### 2.1 Student Records
**Retention Period: 7 years from course completion**

- **Student Registration Records**
  - Full name, NRIC/Passport number, date of birth
  - Contact information (address, phone, email)
  - Registration date and course enrollment details
  - Payment records and receipts

- **Training Progress Records**
  - Module completion timestamps and scores
  - Time spent on each learning section
  - Number of quiz attempts and results
  - Learning path progression data

- **Assessment Records**
  - Quiz responses and scores for each module
  - Final assessment results and timestamps
  - Remedial training records (if applicable)
  - Assessment review and appeals (if any)

- **Certification Records**
  - Certificate issuance date and unique certificate number
  - Digital certificate file and verification hash
  - Certificate delivery confirmation
  - Certificate replacement requests and history

### 2.2 Organizational Records
**Retention Period: 7 years from creation**

- **Personnel Records**
  - Accountable Manager qualifications and certifications
  - Staff training records and competency assessments
  - External contractor agreements and qualifications

- **Quality Assurance Records**
  - Internal audit reports and corrective actions
  - External audit findings and responses
  - Quality metrics and performance indicators
  - Continuous improvement documentation

- **Operational Records**
  - System maintenance logs and updates
  - Security incident reports and responses
  - Business continuity plan activations
  - Regulatory correspondence with CAAS

### 2.3 Technical System Records
**Retention Period: 7 years**

- **System Performance Data**
  - Server uptime and performance metrics
  - User access logs and session data
  - System error logs and resolution records
  - Backup and recovery operation logs

- **Security Records**
  - User authentication logs
  - Data access and modification logs
  - Security breach incidents and responses
  - Penetration testing and vulnerability assessments

## 3. Storage Procedures

### 3.1 Digital Storage Infrastructure

**Primary Storage:**
- Cloud-based storage with Singapore data residency (AWS Singapore region)
- Encrypted storage using AES-256 encryption
- Automated daily backups with 30-day retention
- Real-time replication to secondary data center

**Backup Storage:**
- Secondary cloud storage in different geographic region
- Weekly full backups with 1-year retention
- Monthly archive backups with 7-year retention
- Quarterly backup integrity testing

### 3.2 Data Classification and Security

**Confidential Data (Student Personal Information):**
- Encrypted at rest and in transit
- Access restricted to authorized personnel only
- Multi-factor authentication required
- Regular access review and audit trails

**Internal Data (Operational Records):**
- Standard encryption and access controls
- Role-based access permissions
- Regular backup and version control
- Change management procedures

### 3.3 Physical Storage (if applicable)

**Document Storage:**
- Fireproof filing cabinets for critical hard copies
- Climate-controlled environment
- Access log and security monitoring
- Annual inventory and condition assessment

## 4. Retrieval Procedures

### 4.1 Standard Retrieval Process

**Student Record Requests:**
1. Verify requestor identity and authorization
2. Log retrieval request with timestamp and purpose
3. Access records through secure portal
4. Generate required reports or certificates
5. Document delivery method and confirmation

**Internal Record Access:**
1. Role-based authentication and authorization
2. Search and filter capabilities by multiple criteria
3. Audit trail of all access and modifications
4. Export capabilities with watermarking

### 4.2 Emergency Retrieval

**Business Continuity Access:**
- 24/7 access to critical records via backup systems
- Mobile access for authorized personnel
- Offline backup access procedures
- Emergency contact protocols

### 4.3 Third-Party Requests

**CAAS Audit Requests:**
- Dedicated secure portal for regulatory access
- Pre-formatted reports for common audit requirements
- Real-time data export capabilities
- Compliance officer notification system

## 5. Disposal Procedures

### 5.1 Retention Schedule Management

**Automated Disposal System:**
- Automated identification of records reaching retention limits
- 90-day advance notification before disposal
- Manual review and approval process
- Secure deletion with verification

### 5.2 Secure Disposal Methods

**Digital Records:**
- Multi-pass secure deletion (DoD 5220.22-M standard)
- Cryptographic key destruction for encrypted data
- Physical destruction of storage media when decommissioned
- Certificate of destruction from disposal vendor

**Physical Records:**
- Professional document shredding service
- Certificate of destruction with serial numbers
- Witnessed destruction for highly sensitive documents
- Environmental compliance for disposal methods

### 5.3 Legal Hold Procedures

**Litigation or Investigation Hold:**
- Immediate suspension of disposal for relevant records
- Legal hold notification system
- Segregation of held records
- Documentation of hold duration and release

## 6. Technical Implementation

### 6.1 Database Structure

**Student Management System:**
```sql
-- Core student records table
CREATE TABLE students (
    student_id UUID PRIMARY KEY,
    nric_passport VARCHAR(20) ENCRYPTED,
    full_name VARCHAR(100) ENCRYPTED,
    email VARCHAR(100) ENCRYPTED,
    phone VARCHAR(20) ENCRYPTED,
    registration_date TIMESTAMP,
    status VARCHAR(20),
    created_at TIMESTAMP,
    updated_at TIMESTAMP
);

-- Training progress tracking
CREATE TABLE training_progress (
    progress_id UUID PRIMARY KEY,
    student_id UUID REFERENCES students(student_id),
    module_id VARCHAR(20),
    completion_percentage INTEGER,
    time_spent_minutes INTEGER,
    last_accessed TIMESTAMP,
    completed_at TIMESTAMP
);

-- Assessment results
CREATE TABLE assessments (
    assessment_id UUID PRIMARY KEY,
    student_id UUID REFERENCES students(student_id),
    module_id VARCHAR(20),
    attempt_number INTEGER,
    score INTEGER,
    passing_score INTEGER,
    questions_answered JSONB,
    completed_at TIMESTAMP
);
```

### 6.2 Access Control Matrix

| Role | Student Records | Assessment Data | System Logs | Audit Reports |
|------|----------------|----------------|-------------|---------------|
| Accountable Manager | Full Access | Full Access | Full Access | Full Access |
| Training Coordinator | Read/Write | Read/Write | Read Only | Read Only |
| Technical Support | Limited | No Access | Full Access | No Access |
| External Auditor | Read Only | Read Only | Read Only | Read Only |

### 6.3 Audit Trail Specification

**Required Audit Fields:**
- User ID and role
- Action performed (Create, Read, Update, Delete)
- Record type and identifier
- Timestamp (UTC with timezone)
- IP address and session ID
- Before/after values for modifications

## 7. Compliance Monitoring

### 7.1 Regular Reviews

**Monthly Reviews:**
- Storage capacity and performance monitoring
- Access log analysis for unusual patterns
- Backup integrity verification
- Security incident review

**Quarterly Reviews:**
- Retention schedule compliance audit
- Data quality assessment
- System performance optimization
- Disaster recovery testing

**Annual Reviews:**
- Complete system security audit
- Retention policy effectiveness review
- Compliance gap analysis
- Technology upgrade planning

### 7.2 Key Performance Indicators

**System Reliability:**
- 99.9% uptime target
- <2 second average response time
- 100% backup success rate
- Zero data loss incidents

**Compliance Metrics:**
- 100% records retention compliance
- <24 hour response time for audit requests
- Zero unauthorized access incidents
- 100% secure disposal verification

## 8. Integration with Learning Management System

### 8.1 Real-Time Data Capture

**Automated Record Creation:**
- Student registration triggers record creation
- Progress tracking updates in real-time
- Assessment completion generates permanent records
- Certificate issuance creates audit trail

### 8.2 Data Synchronization

**Multi-System Consistency:**
- Real-time synchronization between LMS and record system
- Conflict resolution procedures
- Data validation and integrity checks
- Regular reconciliation processes

## 9. Disaster Recovery and Business Continuity

### 9.1 Recovery Time Objectives

**Critical Systems:**
- Recovery Time Objective (RTO): 4 hours
- Recovery Point Objective (RPO): 1 hour
- Maximum tolerable downtime: 8 hours

### 9.2 Recovery Procedures

**System Failure Response:**
1. Immediate notification to technical team
2. Activation of backup systems
3. Data integrity verification
4. Service restoration and testing
5. Incident documentation and review

## 10. Privacy and Data Protection

### 10.1 PDPA Compliance

**Personal Data Handling:**
- Explicit consent for data collection
- Purpose limitation and data minimization
- Individual access and correction rights
- Breach notification procedures

### 10.2 Data Subject Rights

**Student Rights Management:**
- Right to access personal data
- Right to correct inaccurate data
- Right to data portability
- Right to deletion (subject to retention requirements)

---

**Document Control:**
- **Approved by:** Alan Soon, Accountable Manager
- **Next Review Date:** August 2026
- **Distribution:** CAAS Submission Package, Internal QA File
