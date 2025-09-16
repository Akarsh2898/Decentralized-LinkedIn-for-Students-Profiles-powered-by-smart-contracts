module MyModule::StudentLinkedIn {
    use aptos_framework::signer;
    use std::string::{String};
    
    /// Struct representing a student profile on the decentralized platform
    struct StudentProfile has store, key {
        name: String,           // Student's full name
        university: String,     // University name
        major: String,          // Field of study
        year: u64,             // Academic year (1-4)
        skills: String,         // Comma-separated skills list
        contact_info: String,   // Email or other contact information
        endorsements: u64,      // Number of endorsements received
        is_active: bool,        // Profile status
    }
    
    /// Function to create a new student profile
    public fun create_student_profile(
        student: &signer,
        name: String,
        university: String,
        major: String,
        year: u64,
        skills: String,
        contact_info: String
    ) {
        let profile = StudentProfile {
            name,
            university,
            major,
            year,
            skills,
            contact_info,
            endorsements: 0,
            is_active: true,
        };
        move_to(student, profile);
    }
    
    /// Function to endorse another student's profile
    public fun endorse_student(
        endorser: &signer,
        student_address: address
    ) acquires StudentProfile {
        // Verify endorser has a profile (only students can endorse)
        assert!(exists<StudentProfile>(signer::address_of(endorser)), 1);
        
        // Get the student's profile and increment endorsements
        let student_profile = borrow_global_mut<StudentProfile>(student_address);
        assert!(student_profile.is_active, 2);
        
        student_profile.endorsements = student_profile.endorsements + 1;
    }
}