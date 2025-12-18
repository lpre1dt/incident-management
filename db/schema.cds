using { cuid, managed, sap.common.CodeList } from '@sap/cds/common';

namespace sap.capire.incidents;

/**
 * Incidents
 */
entity Incidents : cuid, managed {
  title         : String(100) @title : 'Title';
  urgency       : Association to Urgency;
  status        : Association to Status;
  customer      : Association to Customers;
  conversation  : Composition of many Conversations on conversation.incident = $self;
}

/**
 * Customers
 */
entity Customers : cuid, managed {
  firstName     : String(50) @title : 'First Name';
  lastName      : String(50) @title : 'Last Name';
  email         : String(100) @title : 'Email';
  phone         : String(30) @title : 'Phone';
  incidents     : Association to many Incidents on incidents.customer = $self;
}

/**
 * Conversations
 */
entity Conversations : cuid, managed {
  incident      : Association to Incidents;
  timestamp     : DateTime @title : 'Timestamp';
  author        : String(100) @title : 'Author';
  message       : String(500) @title : 'Message';
}

/**
 * Urgency Code List
 */
entity Urgency : CodeList {
  key code : String(10);
  criticality : Integer;
}

/**
 * Status Code List
 */
entity Status : CodeList {
  key code : String(10);
  criticality : Integer;
}
