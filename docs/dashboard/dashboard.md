# Dashboard Options for Smart City FIWARE project 

## Context and Problem Statement

For the Smart City FIWARE project, a solution is needed to display the collected sensor data in a dashboard.

## Decision Drivers

- Simple Visualizations: Stat, Time Series, Bar, Pie, Scatterplot, Table
- Optional Visualizations: Geomap Heatmap
- Database Integration: PostgreSQL, TimescaleDB, MongoDB
- User Management + Access Control
- Improvement over Grafana:
- Complex Visualizations: Geomap, Heatmap
- LDAP Support
- Monitoring & Alerting
- Extension through Plugins
- Open Source
- Still maintained
- Easy to use
- Displaying of maps
- Support for TimescaleDB
- Null Value Handling

## Considered Options

- [Grafana](https://github.com/grafana/grafana)
- [Streamlit](https://streamlit.io/)
- [mozaik](https://github.com/plouc/mozaik)
- [Freeboard](https://github.com/Freeboard/freeboard)
- [Re:Dash](https://github.com/getredash/redash)
- [smashing](https://smashing.github.io/#getting-started)
- [D3](https://github.com/d3/d3?tab=readme-ov-file)
- [SuperSet](https://github.com/apache/superset)

## Decision Outcome

Chosen option: "Grafana", because it is already in use and provides the closest feature set to the requirements. We ar thinking of extending Grafana by some custom extensions to display geo data and handle null values better.

Superset is also a good alternative, but there are too many options missing, that Grafana provides. Superset has much more options for visualizations and data exploration. So it could be an option in the future, when the missing requirements are fullfilled.

## Pros and Cons of the Options

### [Grafana](https://github.com/grafana/grafana)

**Pros:**

- Rich Visualization Capabilities: Grafana excels in providing a variety of simple visualizations including stat panels, time series, bar charts, pie charts, scatter plots, and tables, which can be easily customized.
- Advanced Visualizations Supported: It supports complex visualizations like geomaps and heatmaps, useful for geographic data representation and density visualization.
- Extensive Database Support: Grafana works with a wide range of databases including PostgreSQL, TimescaleDB, and MongoDB, allowing for flexible data sourcing.
- User Management and Access Control: Offers robust user management and access control options, ensuring secure access to dashboards.
- Open Source and Extensible: Being open-source, it allows for customization and extension through plugins, which can add or enhance features.
- Active Community and Ongoing Maintenance: Grafana has a strong community support and is regularly updated, ensuring it stays relevant with new features and security updates.
- Ease of Use: Grafana is known for its user-friendly interface, making it accessible for users with varying levels of technical expertise.

**Cons:**

- Limited Native Alerting Features: While Grafana offers monitoring and alerting, its native capabilities can be somewhat basic compared to specialized monitoring tools, often requiring plugins or external tools to achieve advanced monitoring.
- Complexity in Advanced Features: While basic usage is straightforward, using advanced features like detailed geomapping or custom plugin development can require a steep learning curve and significant technical expertise.
- Performance Issues with Large Datasets: Users have reported that Grafana can become slow when handling very large datasets or when configured with multiple complex dashboards.
- Lacks Built-In Support for LDAP in Open Source Version: LDAP support is available but primarily in the enterprise version, which might be a limitation for users relying on the open-source version.
- Handling of Null Values: Handling null values in data can sometimes be problematic, requiring custom configuration to ensure data accuracy and visualization integrity.

### [Streamlit](https://streamlit.io/)

- Bad, because dashboards must be programmed instead of editing it with a wysiwyg editor.

### [mozaik](https://github.com/plouc/mozaik)

- Bad, because it is not maintained anymore

### [Freeboard](https://github.com/Freeboard/freeboard)

Freeboard is a HTML-based engine for dashboards. It provides a plugin architecture to creating datasources and dashboards.

- Bad, because it is not maintained anymore

### [Re:Dash](https://github.com/getredash/redash)

Redash is an open-source tool designed for data visualization and collaboration, making it easier for teams and businesses to gain insights from their data in an understandable way. It enables users to conduct SQL queries on their databases directly, visualize the results, and create dashboards that update in real-time. Redash supports a wide range of data sources including PostgreSQL, MySQL, Google BigQuery, MongoDB, Presto, Oracle, Amazon Redshift, and many others.

- Good, because it is simple to use.
- Bad, because it is complicated / not possible to develop custom plugins.
- Bad, because it has not many plugins for visualization.

### [smashing](https://smashing.github.io/#getting-started)

Smashing provides a flexible platform for creating dashboards, utilizing HTML and CSS to allow for nearly any conceivable design. Dashboards created with Smashing are known for their modern and appealing aesthetics.

- **Pros:**
  - **Flexibility:** Thanks to the use of HTML and CSS, users can achieve a high degree of customization, enabling the creation of nearly any dashboard configuration.
  - **Aesthetic Appeal:** Dashboards look great and modern.
- **Cons:**
  - **Effort Required:** Creating a dashboard demands considerably more effort compared to platforms with UI admin panels. It involves:
    1. Dashboard creation through the command line interface (CLI) of the container.
    2. Programming and creating jobs in Ruby to display data, which adds to the development time.
  - **Outdated Releases:** The last release was almost two years ago, raising concerns about ongoing maintenance and updates.
  - **Maintenance Concerns:** It's a fork of a project (Shopify's Dashing) that has not been maintained since 2018 ([reference](https://github.com/Shopify/dashing/issues/711)), which may pose risks in terms of long-term viability and support.

### [D3](https://github.com/d3/d3?tab=readme-ov-file)

D3 is a JavaScript library that offers powerful and flexible capabilities for data visualization. It is well-suited for creating complex, interactive, and dynamic visualizations.

- **Pros:**
  - **Flexibility:** D3's approach allows for the creation of almost any kind of data visualization, offering extensive control over the final presentation.
  - **Active Development:** Frequent releases (the last one was 3 weeks ago) indicate active development and support, ensuring the library remains current with web standards and technologies.
- **Cons:**

  - **Flat Learning Curve:** The complexity D3 can pose a significant learning challenge, especially for new employees or students who may require more time to become productiv.

  - **Development Requirement:** Unlike platforms that offer ready-to-use products, utilizing D3 requires the development of a web application or a similar platform to create the visualizations.

### [Superset](https://github.com/apache/superset)

Superset is an open-source data exploration and visualization platform that is often compared to Grafana for its dashboard capabilities. It provides a modern approach to data visualization, with a focus on ease of use and flexibility.

- **Pros:**
  - **Similarity to Grafana with a Modern Twist:** Offers a powerful dashboard experience that feels familiar to Grafana but with a more modern aesthetic and user interface.
  - **Reusable Charts:** Charts can be reused across multiple dashboards, and both charts and queries can be saved for future use, enhancing efficiency and consistency.
  - **Modern Data Display:** Supports a modern approach to displaying data, including rows, columns, and tabs, providing a versatile set of options for data presentation.
  - **Filtering and Drill-Down:** Allows for filtering and drill-down capabilities, enabling users to interact with the data and explore it in more detail.
- **Cons:**
  - **Limited Time Range and Variable Support:** Unlike Grafana, Superset does not support time ranges and variables, which may limit dashboard customization and interactivity.
  - **Bugs with Timescale Functions:** sometime the time_bucket() function throws an error.
  - **Smaller Community:** Superset has a smaller community compared to Grafana, which may result in fewer resources, less community support, and a slower pace of issue resolution and feature development.
  - **One query restriction:** Only one query can be used for each chart.
  - **Limited Control in Chart Creation:** Although Apache Superset allows users to create SQL queries in the SQL Lab, the tool often automatically modifies these queries during chart creation, which can reduce users' control over their queries and the resulting visualizations.
