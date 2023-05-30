SELECT * FROM peers;
SELECT peer, task, date,
          CASE WHEN checks_status(checks.id) = 'success' 
          THEN true ELSE false 
          END AS status
      FROM checks
      JOIN peers ON peers.nickname = checks.peer
      JOIN p2p ON p2p.check_id = checks.id
      WHERE (p2p.state = 'failure' OR p2p.state = 'success') AND
          EXTRACT(MONTH FROM date) = EXTRACT(MONTH FROM birthday)
              AND EXTRACT(DAY FROM date) = EXTRACT(DAY FROM birthday)
      GROUP BY checks.id;
SELECT * FROM birthday_percentage();