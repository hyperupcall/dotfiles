#!/usr/bin/env node
import { Octokit } from '@octokit/rest'
import dotenv from 'dotenv'

dotenv.config()

const hyperupcall = new Octokit({
	auth: process.env.GITHUB_TOKEN_HYPERUPCALL,
})

const captainWoofers = new Octokit({
	auth: process.env.GITHUB_TOKEN_CAPTAINWOOFERS,
})

await hyperupcall.rest.users.getAuthenticated()

await protectBranches()

async function sendInvites() {
	const repos = await hyperupcall.paginate(
		hyperupcall.repos.listForAuthenticatedUser,
		{
			visibility: 'all',
			affiliation: 'owner',
			per_page: 100,
		},
	)
	for (const repo of repos) {
		if (repo.archived) continue

		const owner = repo.owner.login
		const repoName = repo.name
		const username = 'captain-woofers'

		console.log(`Adding ${username} to ${owner}/${repoName}...`)
		await hyperupcall.rest.repos.addCollaborator({
			owner,
			repo: repoName,
			username,
		})
	}
}

async function acceptInvites() {
	const invitations = await captainWoofers.paginate(
		captainWoofers.repos.listInvitationsForAuthenticatedUser,
		{
			per_page: 100,
		},
	)
	for (const invitation of invitations) {
		const owner = invitation.repository.owner.login
		const repo = invitation.repository.name
		const id = invitation.id

		console.log(`Accepting invitation for ${owner}/${repo} (${id})`)
		await captainWoofers.repos.acceptInvitationForAuthenticatedUser({
			invitation_id: id,
		})
	}
}

async function protectBranches() {
	const repos = await hyperupcall.paginate(
		hyperupcall.repos.listForAuthenticatedUser,
		{
			visibility: 'all',
			affiliation: 'owner',
			per_page: 100,
		},
	)
	for (const repo of repos) {
		if (repo.private) continue

		const owner = repo.owner.login
		const repoName = repo.name
		const branch = repo.default_branch

		console.log(
			`Updating branch protection on ${branch} to ${owner}/${repoName}...`,
		)
		await hyperupcall.repos.updateBranchProtection({
			owner,
			repo: repoName,
			branch,
			required_status_checks: null,
			enforce_admins: false,
			required_pull_request_reviews: null,
			restrictions: null,
			required_conversation_resolution: true,
		})
	}
}