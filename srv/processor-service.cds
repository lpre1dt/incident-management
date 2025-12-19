using { sap.capire.incidents as my } from '../db/schema';

/**
 * Service for processing incidents
 */
service ProcessorService {
  entity Incidents as projection on my.Incidents;
  entity Customers as projection on my.Customers;
  entity Conversations as projection on my.Conversations;
  
  @readonly entity Urgency as projection on my.Urgency;
  @readonly entity Status as projection on my.Status;
}

// Annotations for Fiori Elements List Report
annotate ProcessorService.Incidents with @(
  odata.draft.enabled,
  Common.SemanticKey : [title],
  UI.LineItem : [
    { Value : title, Label : 'Title' },
    { Value : customer.lastName, Label : 'Customer' },
    { 
      Value : status.name, 
      Label : 'Status', 
      Criticality : status.criticality 
    },
    { 
      Value : urgency.name, 
      Label : 'Urgency', 
      Criticality : urgency.criticality 
    },
    { Value : modifiedAt, Label : 'Modified At' }
  ],
  UI.HeaderInfo : {
    TypeName : 'Incident',
    TypeNamePlural : 'Incidents',
    Title : { Value : title },
    Description : { Value : customer.lastName }
  },
  UI.SelectionFields : [ status_code, urgency_code, customer_ID ],
  UI.FieldGroup #Details : {
    Data : [
      { Value : title, Label : 'Title' },
      { Value : customer_ID, Label : 'Customer' },
      { Value : status_code, Label : 'Status' },
      { Value : urgency_code, Label : 'Urgency' }
    ]
  },
  UI.Facets : [
    {
      $Type : 'UI.ReferenceFacet',
      Label : 'Details',
      Target : '@UI.FieldGroup#Details'
    },
    {
      $Type : 'UI.ReferenceFacet',
      Label : 'Conversations',
      Target : 'conversation/@UI.LineItem'
    }
  ]
);

annotate ProcessorService.Incidents with {
  ID @(
    UI.Hidden,
    Common.Text : title
  );
  title @(
    title : 'Title',
    Common.FieldControl : #Mandatory
  );
  customer @(
    title : 'Customer',
    Common.Text : customer.lastName,
    Common.FieldControl : #Mandatory,
    Common.ValueList : {
      CollectionPath : 'Customers',
      Parameters : [
        { $Type : 'Common.ValueListParameterInOut', LocalDataProperty : customer_ID, ValueListProperty : 'ID' },
        { $Type : 'Common.ValueListParameterDisplayOnly', ValueListProperty : 'firstName' },
        { $Type : 'Common.ValueListParameterDisplayOnly', ValueListProperty : 'lastName' },
        { $Type : 'Common.ValueListParameterDisplayOnly', ValueListProperty : 'email' }
      ]
    }
  );
  status @(
    title : 'Status',
    Common.Text : status.name,
    Common.FieldControl : #Mandatory,
    Common.ValueListWithFixedValues
  );
  urgency @(
    title : 'Priority',
    Common.Text : urgency.name,
    Common.FieldControl : #Mandatory,
    Common.ValueListWithFixedValues
  );
}

annotate ProcessorService.Conversations with @(
  UI.LineItem : [
    { Value : timestamp, Label : 'Timestamp' },
    { Value : author, Label : 'Author' },
    { Value : message, Label : 'Message' }
  ],
  UI.FieldGroup #ConversationDetails : {
    Data : [
      { Value : author, Label : 'Author' },
      { Value : message, Label : 'Message' }
    ]
  }
);

annotate ProcessorService.Conversations with {
  ID @UI.Hidden;
  author @(
    title : 'Author',
    Common.FieldControl : #Mandatory
  );
  message @(
    title : 'Message',
    UI.MultiLineText,
    Common.FieldControl : #Mandatory
  );
  timestamp @(
    title : 'Timestamp',
    Common.FieldControl : #ReadOnly
  );
}

annotate ProcessorService.Customers with @(
  UI.LineItem : [
    { Value : firstName, Label : 'First Name' },
    { Value : lastName, Label : 'Last Name' },
    { Value : email, Label : 'Email' },
    { Value : phone, Label : 'Phone' }
  ],
  UI.HeaderInfo : {
    TypeName : 'Customer',
    TypeNamePlural : 'Customers',
    Title : { Value : lastName },
    Description : { Value : firstName }
  },
  UI.SelectionFields : [ lastName, email ],
  UI.FieldGroup #Details : {
    Data : [
      { Value : firstName },
      { Value : lastName },
      { Value : email },
      { Value : phone }
    ]
  },
  UI.Facets : [
    {
      $Type : 'UI.ReferenceFacet',
      Label : 'Details',
      Target : '@UI.FieldGroup#Details'
    },
    {
      $Type : 'UI.ReferenceFacet',
      Label : 'Incidents',
      Target : 'incidents/@UI.LineItem'
    }
  ]
);
