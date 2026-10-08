#import "template.typ": *

#show: resume.with(
  name: "Varun Mehrishi",
  title: "Software Development Engineer II, Amazon | Distributed Systems, Payments and Audit Platforms",
  // Build with `--input web=1` (or sys_inputs web=1) for the public site: no email or phone, LinkedIn is the channel.
  contacts: if sys.inputs.at("web", default: "0") == "1" {
    ("Hyderabad, India", "linkedin.com/in/vmehrishi", "github.com/varunmehrishi")
  } else {
    ("Hyderabad, India", "varunmehrishi@gmail.com", "+91 99280 30337", "linkedin.com/in/vmehrishi", "github.com/varunmehrishi")
  },
  paper: "a4", margin: 0.5in, size: 10pt,
)

= Professional Summary
Software engineer with 7 years at Amazon building event-driven microservices and REST APIs for financial systems that audit and pay carrier invoices across tens of billions of dollars of annual transportation spend. Designed and led a cross-team enrichment service, a dead-letter-queue platform adopted by six teams and a configurable dispute-detection engine; led five engineers and two interns to launch; reviewer of record for six payment and audit services where one defect costs millions. Seven years on-call, incident lead for Sev2 events. Java, AWS, Spark, Rust.

= Work Experience
#entry("Software Development Engineer II, Amazon (Transportation Financial Systems), Hyderabad", "Jul 2022 – Present")[
- Designed the end-to-end architecture of Meghnad, a shared enrichment service filling missing shipment scan data from partner APIs and web sources for an org-wide audit-automation program; led three engineers to an Apr 2026 launch. Raised shipment scan-data coverage from *98% to 99.8%*; no DLQ or latency incidents since.
- Built its asynchronous pipeline (SNS/SQS, Parquet batches, cross-account S3, Spark on EMR) with distributed rate limiting to partner quotas, retries and health checks within a 2-hour SLA; shipped a decision-rollback control across three services in three days to unblock launch.
- Led Charge Type Payments to *100% carrier coverage*: owned readiness with four partner teams, grew EU from 15 to 130+ carriers and launched 230+ NA carriers with zero incidents; led two engineers to replace contention-prone optimistic locking with FIFO serialization by audit-item identity.
- Drove mitigation of an incident with *\$2.5M* in payments stuck, with the on-call senior engineer: sized the blast radius with a SQL query against the data warehouse, replaced last-write-wins amount merging with per-transaction summation, ran a staged replay under change management. Released in five days.
- Designed Configurable Property Dispute Detection (comparator abstraction, YAML model with polymorphic tags) so new dispute types ship as configuration; fixed a *\$17M* duplicate-resolution defect with an order-independent equivalence hash; cut DynamoDB storage cost *70%* via record compression.
- Reviewed design and code as engineer of record for six services paying carriers at multi-billion-dollar annual scale (*137 reviews in 2025*), blocking defects such as paid-amount aggregation before release; mentored two interns, one hired. Led incident recovery for a heap-exhaustion cascade and an EU surge (fleet 8 to 40 hosts); wrote recovery CLIs that restored 1,113 oversized records with zero failures.
]
#entry("Software Development Engineer, Amazon (Transportation Financial Systems)", "Nov 2019 – Jun 2022")[
- Authored TFS Helix, the dead-letter-queue platform (Java 11, jOOQ, Lambda, Multi-AZ MySQL with RDS Proxy, SQS, S3, CDK deployed through CI/CD pipelines) that prevents message loss, surfaces stack traces and redrives after fixes; adopted by *six teams* and still the shared platform in 2026.
- Built shared CDK alarm constructs rolled to four services; made Payment Authorization rules declarative through generic applicability criteria and deciders.
- Owned month-end close for auditing (2021 to 2022): resolved *35 finance-critical tickets* with zero escalations, reconciling payment data with SQL and Python; onboarded India carriers with 189 GST translation codes.
]
#line-entry[*Microsoft Consulting Services*, Associate Project Manager, Hyderabad][Jul 2019 – Nov 2019]

= Projects
- #link("https://github.com/varunmehrishi/rdb-parser")[rdb-parser] (Rust, MIT): parser-combinator reader for the Redis RDB format with unit tests. #link("https://github.com/varunmehrishi/Hackattic")[Hackattic] (Rust): ten systems challenges on one trait-based async runner (rayon, FFT, scrypt, WebSocket). #box[github.com/varunmehrishi]

= Skills
#skills(
  ("Languages", "Java, TypeScript, Scala, Python, Rust, SQL, Bash"),
  ("AWS", "Lambda, SQS, SNS, DynamoDB, S3, Kinesis Data Firehose, Step Functions, EMR, RDS, API Gateway, CloudWatch, IAM, CDK v2, Athena, Redshift"),
  ("Tools and practices", "REST APIs, Smithy, Guice, Dagger, jOOQ, JUnit, Apache Spark, Elasticsearch, Node.js, React, CI/CD; system design, database design (DynamoDB, MySQL), message queues (SQS, SNS, Kinesis), caching, event-driven architecture, idempotency, observability, load and regression testing, on-call and incident management, code review, mentoring"),
)

= Education
#line-entry[*Manipal University Jaipur*, B.Tech in Computer Science and Engineering, CGPA 9.36/10][2015 – 2019]
