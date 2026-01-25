# FindMeHouseDashboard

This is a requirement code challenge I wrote during the hiring process in Sigma Logic 

This application built with Elixir, Phoenix Liveview and PostgreSQL monitors the health of each component of the FindMeHouse Application and displays their status in real time without the need for refreshing of page.

## Features
- Automatic Health Checks: Background processes monitor services every 5-10 seconds

- Real-time Monitoring: Updates UI with status of each service in real time
- Sleek Interface: Responsive Interface built with Liveview and Tailwind with intuitive color 
schemes to see status of each service in a glance.

- Fault Tolerant: Independent Genserver process for each service with ability to restart any failed process without disturbing the entire system.

- Containerized: Easy development, deployment and consistent behaviour of application in any environment with Docker

## Tech Stack
- Backend: Elixir, Phoenix Framework, PostgreSQL

- Frontend: Phoenix LiveView, Tailwind CSS

- Real-time: Phoenix PubSub

- Real-time Service Monitoring: GenServer-based health checks

- Fault Tolerance: Supervised Process with automatic restarts

- Containerization: Docker & Docker Compose

## Prerequisites
- Docker & Docker Compose

## Quick Setup
- Run this command on your terminal: `git clone https://github.com/andrewinsoul/find_me_house_dashboard`

- Run the command to switch directory to the project directory: `cd find_me_house_dashboard`

- Run the command to start up docker: `docker-compose up --build`

- open http://localhost:4000 on your browser when docker is done building

## Database Setup
The application is seeded with 5 services, each representing a component of the find_me_house app:
- Media Storage Service

- Database Service

- Auth Service

- Payment Service

- AI Agent Service

## Testing
Run `mix test` to run all test suites

## Architecture
A Genserver process fetches all services from the DB. Let us call this process "spin_up_services_process". 
This process now loads each service into a DynamicSupervisor 
The DynamicSupervisor now supervises and automatically restarts different Genserver processes with each Genserver process for a service.
In the application supervisor, the DynamicSupervisor and "spin_up_services" Genserver process are added as part of the application's children. The implication of this is that once the application is loaded, you see the real-time monitoring of the available services in the database without any interaction

## Acknowledgments
- Phoenix Framework team for LiveView and other Phoenix Tools

- Elixir community for excellent tooling

- Docker for containerization
