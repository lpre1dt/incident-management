const cds = require('@sap/cds');

module.exports = cds.service.impl(async function() {
  const { Incidents, Status } = this.entities;

  // Set default status for new incidents
  this.before('CREATE', 'Incidents', req => {
    if (!req.data.status_code) {
      req.data.status_code = 'N'; // New
    }
  });

  // Add validation
  this.before(['CREATE', 'UPDATE'], 'Incidents', req => {
    if (!req.data.title || req.data.title.length < 5) {
      req.error(400, 'Title must be at least 5 characters long');
    }
  });

  // After creating an incident, log it
  this.after('CREATE', 'Incidents', async (incident, req) => {
    console.log(`New incident created: ${incident.title} (ID: ${incident.ID})`);
  });
});
