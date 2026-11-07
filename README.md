# CoachWise – Coaching Institute Management Platform

This the live web app link:
arun-institute.varunparida06.workers.dev

A responsive web application designed to simplify the day-to-day operations of a commerce coaching institute. CoachWise brings student management, attendance tracking, enrollment, payment verification and study materials into one platform.

Built to address practical administrative challenges and provide students with an accessible digital experience across desktop and mobile devices.

## Overview

Managing a coaching institute often involves handling student records, tracking attendance, processing fee payments and distributing study materials through separate channels.

**CoachWise** aims to bring these activities together in a centralized platform, reducing manual work and making essential information easier to access for both students and administrators.

## Key Features

### Student Features
- **Attendance Management** – Access attendance information through the student interface.
- **Online Enrollment** – Submit enrollment requests digitally.
- **Payment Requests** – Submit UPI transaction details for fee payment verification.
- **Study Materials** – Browse available academic notes and resources.
- **Free and Paid Notes** – Access free materials and request access to paid materials.
- **Responsive Interface** – Use the application on desktop, tablet and mobile devices.

### Admin Features
- **Admin Dashboard** – Manage institute-related information from a centralized interface.
- **Payment Management** – Review payment requests and verify transactions.
- **Student Management** – Manage student information and records.
- **Attendance Management** – Maintain student attendance records.
- **Enrollment Management** – Review incoming enrollment applications.
- **Study Material Management** – Manage and publish learning resources.
- **Announcements** – Share important institute updates with students.

## Technology Stack

| Category | Technology |
|---|---|
| Frontend | React.js |
| Build Tool | Vite |
| Styling | Tailwind CSS |
| Backend Services | Supabase |
| Database | PostgreSQL (Supabase) |
| Authentication | Supabase / application authentication |
| File Storage | Supabase Storage |
| Version Control | Git & GitHub |
| Cloud Deployment | Cloudflare Workers |

## Application Architecture

CoachWise uses a cloud-based architecture:

1. **Frontend:** React handles the user interface and application interactions.
2. **Backend Services:** Supabase provides database, authentication and storage capabilities.
3. **Database:** PostgreSQL stores application records such as students, attendance, payments and enrollment requests.
4. **Storage:** Supabase Storage manages study material files.
5. **Hosting:** Cloudflare Workers serves the built frontend application.

## Project Structure

```text
institute_manager/
│
├── src/
│   └── Application source code
│
├── supabase/
│   └── Supabase configuration and database resources
│
├── public/
│   └── Static assets (if present)
│
├── .env.example
├── .gitignore
├── index.html
├── package.json
├── package-lock.json
└── wrangler.jsonc
```

## Getting Started

### Prerequisites

Make sure you have the following installed:

- Node.js (LTS recommended)
- npm
- Git
- A Supabase project

### 1. Clone the repository

```bash
git clone https://github.com/Varun-Parida/institute_manager.git
```

### 2. Navigate to the project directory

```bash
cd institute_manager
```

### 3. Install dependencies

```bash
npm install
```

### 4. Configure environment variables

Create a `.env` file in the project root.

You can use `.env.example` as a reference.

```env
VITE_SUPABASE_URL=your_supabase_project_url
VITE_SUPABASE_ANON_KEY=your_supabase_anon_key
VITE_ADMIN_PASSWORD=your_admin_password
```

Replace the placeholder values with the appropriate project configuration.

**Security note:** Never commit your actual `.env` file or expose a Supabase service-role key in frontend code. Client-side admin passwords are not a substitute for secure server-side authentication and authorization.

### 5. Start the development server

```bash
npm run dev
```

Vite will provide a local development URL, usually:

```text
http://localhost:5173
```

### 6. Build for production

```bash
npm run build
```

The production-ready files will be generated inside the `dist/` directory.

To preview the production build locally:

```bash
npm run preview
```

## Supabase Configuration

CoachWise uses Supabase for its cloud backend.

To run your own instance:

1. Create a project in Supabase.
2. Configure the required database tables.
3. Configure Row Level Security (RLS) policies.
4. Set up the required Storage buckets and access policies.
5. Add your Supabase project URL and public client key to `.env`.
6. Configure authentication and authorization for administrative operations.

Make sure database permissions and Storage policies are configured before using the application with real student data.

## Cloud Deployment

The project includes a `wrangler.jsonc` configuration for Cloudflare Workers Static Assets.

Basic deployment workflow:

1. Build the application:

```bash
npm run build
```

2. Configure the required environment variables in Cloudflare.
3. Deploy:

```bash
npx wrangler deploy
```

Cloudflare Workers can serve the production frontend, while Supabase continues to provide the backend services.

## Responsive Design

CoachWise is designed with a responsive interface to support different screen sizes.

- Desktop: Optimised layouts for larger screens.
- Tablet: Adaptive layouts for medium-sized devices.
- Mobile: Mobile-first navigation and layouts for smaller screens.

## Future Improvements

Potential areas for further development include:

- Enhanced student analytics and attendance reports.
- More detailed payment reporting.
- Improved notification workflows.
- Additional administrative tools.
- Further improvements to security and access management.

## Project Information

**Project Name:** CoachWise  
**Repository:** [institute_manager](https://github.com/Varun-Parida/institute_manager)  
**Developer:** Varun Parida  
**Project Type:** Client Web Application  
**Category:** Education Technology / Institute Management

---

*Built to solve a practical problem through technology, with a focus on usability, accessibility and efficient institute management.*

