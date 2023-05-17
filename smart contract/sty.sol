// SPDX-License-Identifier: GPL-3.0

pragma solidity ^0.8.0;

contract GradeSubmission {
    struct Grade {
        uint256 marks;
        string grade;
        bool approved;
    }

    mapping(uint256 => Grade) grades;
    address public faculty;
    address public higherAuthority;

    modifier onlyFaculty() {
        require(msg.sender == faculty,
         "Only the faculty can call this function.");
        _;
    }

    modifier onlyHigherAuthority() {
        require(msg.sender == higherAuthority,
         "Only the higher authority can call this function.");
        _;
    }

    constructor(address _faculty, address _higherAuthority) {
        faculty = _faculty;
        higherAuthority = _higherAuthority;
    }

    function submitGrade(uint256 rollNumber, uint256 marks) public onlyFaculty {
        require(marks <= 100, "Marks should be less than or equal to 100");
        require(bytes(grades[rollNumber].grade).length == 0,
         "Grade already submitted for this roll number");
        string memory grade = getGrade(marks);
        grades[rollNumber] = Grade(marks, grade, false);
    }

    function getGrade(uint256 marks) internal pure returns (string memory) {
        if (marks >= 90) {
            return "A+";
        } else if (marks >= 80) {
            return "A";
        } else if (marks >= 70) {
            return "B+";
        } else if (marks >= 60) {
            return "B";
        } else if (marks >= 50) {
            return "C+";
        } else if (marks >= 40) {
            return "C";
        } else {
            return "F";
        }
    }

    function approveGrade(uint256 rollNumber) public onlyHigherAuthority {
        require(bytes(grades[rollNumber].grade).length > 0, 
        "No grade submitted for this roll number");
        require(!grades[rollNumber].approved,
         "Grade already approved");
        grades[rollNumber].approved = true;
    }

    function viewMyGrade(uint256 rollNumber) public view returns
     (uint256, string memory, bool) {
        require(msg.sender == faculty || msg.sender == higherAuthority, 
        "Only faculty or higher authority can view the grade.");
        require(bytes(grades[rollNumber].grade).length > 0, 
        "No grade submitted for this roll number");
        return (grades[rollNumber].marks, grades[rollNumber].grade,
         grades[rollNumber].approved);
    }
}