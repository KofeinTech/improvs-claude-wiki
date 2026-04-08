# Fantabase

**Fantasy Football Supercharged by AI**

Fantabase helps fantasy football players make better decisions faster. It aggregates news from across the internet, filters it to what matters for your roster, and gives you an AI assistant that answers any fantasy question instantly.

- Website: [fantabase.app](https://fantabase.app)
- Mobile app: iOS and Android (currently in waitlist)
- GitHub org: [KofeinTech](https://github.com/KofeinTech)
- Repo: [KofeinTech/fantabase-backend](https://github.com/KofeinTech/fantabase-backend) (monorepo -- backend, frontend, mobile)

## Features

### Personalized Feed
Curated news feed that only shows content relevant to your roster. Aggregates from X (Twitter), YouTube, and RSS sources -- turns 8 hours of weekly scrolling into 15 minutes.

### Howie Wynn (AI Assistant)
AI-powered fantasy football manager trained on extensive football content. Ask any question -- player comparisons, trade evaluations, start/sit decisions, waiver wire pickups -- and get instant answers with stats to back them up.

### Lineup Optimization
AI-driven start/sit recommendations that factor in weather, Vegas odds, matchup history, and projections. Helps you set the best lineup every week.

### Smart Alerts and Watchlist
Real-time push notifications for injuries, trades, and lineup changes before kickoff. Never miss a critical update that affects your team.

### League Integrations
- **Sleeper** -- one-click sync of rosters, drafts, and transactions
- **Yahoo Fantasy** -- full integration with rosters and transactions

### Player Stats and Insights
Comprehensive NFL player stats with game logs, dynasty values, and AI-generated analysis. Everything you need to evaluate players in one place.

### Video and Content Processing
Automatically transcribes football videos and podcasts, making them searchable. Find the exact take you're looking for without watching hours of content.

## Team

| Role | Person |
|------|--------|
| Backend developer | Dmytro Zalis |
| Frontend developer | tkachenko-yevhenii |

## Tech Stack

| Layer | Technologies |
|-------|-------------|
| Backend | .NET 8, ASP.NET Core, Entity Framework Core, MySQL 8.0 |
| Web frontend | React 19, TypeScript |
| AI | Azure OpenAI, OpenAI, AssemblyAI |
| Data sources | SportsDataIO (NFL stats), Sleeper API, Yahoo Fantasy, X API, YouTube |
| Infrastructure | Azure Container Apps, Azure Storage, Firebase (auth + push notifications) |
| Monitoring | Azure Application Insights |

## Environments

| Environment | Web |
|-------------|-----|
| Local | http://localhost:3000 (API on :5001) |
| Staging | [fantabase-frontend...westus2](https://fantabase-frontend.wittyocean-de44e066.westus2.azurecontainerapps.io) |
| Production | [fantabase-frontend...eastus](https://fantabase-frontend.graypebble-5a356318.eastus.azurecontainerapps.io) |

## Development

```bash
# Start all services locally
docker compose -f docker-compose.dev.yml up --build
```

Deployment is manual via shell scripts -- `deploy-backend.sh`, `deploy-frontend.sh`, `deploy-prod.sh`. Requires Azure CLI login.

## Documentation

Additional docs in the repo under `docs/` -- Sleeper/Yahoo setup, content architecture, notification system, and smoke testing guide.
