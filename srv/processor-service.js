const cds = require('@sap/cds');

module.exports = cds.service.impl(async function() {
  const { Incidents, Status, Conversations } = this.entities;

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

  // Action: Set to High Urgency
  this.on('setToHighUrgency', 'Incidents', async (req) => {
    const { comment } = req.data;
    const { ID } = req.params[0];

    // Validate comment
    if (!comment || comment.trim().length === 0) {
      return req.error(400, 'Comment is required');
    }

    // Update urgency to High
    await UPDATE('ProcessorService.Incidents')
      .set({ urgency_code: 'H' })
      .where({ ID: ID });

    // Add conversation entry
    await INSERT.into(Conversations).entries({
      incident_ID: ID,
      timestamp: new Date().toISOString(),
      author: req.user.id || 'System',
      message: `Urgency set to HIGH. Reason: ${comment}`
    });

    // Return updated incident
    return SELECT.one.from(Incidents).where({ ID: ID });
  });
});
