const cds = require('@sap/cds');

module.exports = cds.service.impl(async function() {
  const { Incidents, Conversations } = this.entities;

  // Set default values
  this.before('CREATE', 'Incidents', req => {
    if (!req.data.status_code) {
      req.data.status_code = 'N'; // New
    }
    if (!req.data.urgency_code) {
      req.data.urgency_code = 'M'; // Medium
    }
  });

  // Validation
  this.before(['CREATE', 'UPDATE'], 'Incidents', req => {
    if (!req.data.title || req.data.title.length < 5) {
      req.error(400, 'Title must be at least 5 characters long');
    }
  });

  // After creating an incident, log it
  this.after('CREATE', 'Incidents', async (incident, req) => {
    console.log(`New incident created: ${incident.title} (ID: ${incident.ID})`);
  });

  // Action: Set to High Urgency
  this.on('setToHighUrgency', 'Incidents', async (req) => {
    const { comment } = req.data;
    const { ID, IsActiveEntity } = req.params[0];

    // Validate comment
    if (!comment || comment.trim().length === 0) {
      return req.error(400, 'Comment is required');
    }

    // Check if incident exists and urgency is not already High
    const incident = await SELECT.one.from(Incidents).where({ ID, IsActiveEntity });
    
    if (!incident) {
      return req.error(404, 'Incident not found');
    }

    if (incident.urgency_code === 'H') {
      return req.error(400, 'Incident urgency is already set to High');
    }

    // Update urgency to High
    await UPDATE(Incidents)
      .set({ urgency_code: 'H' })
      .where({ ID, IsActiveEntity });

    // Add conversation entry
    await INSERT.into(Conversations).entries({
      incident_ID: ID,
      timestamp: new Date().toISOString(),
      author: req.user.id || 'System',
      message: `Urgency set to HIGH. Reason: ${comment}`
    });

    // Return updated incident with all associations expanded
    return SELECT.one.from(Incidents)
      .where({ ID, IsActiveEntity })
      .columns(i => {
        i('*'),
        i.customer(c => c('*')),
        i.status(s => s('*')),
        i.urgency(u => u('*')),
        i.conversation(conv => conv('*'))
      });
  });
});
