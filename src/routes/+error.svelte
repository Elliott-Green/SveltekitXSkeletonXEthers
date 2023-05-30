<script lang="ts">
	import { page } from '$app/stores';

	let errorMessage = $page?.error?.message ?? 'unknown error';
	let errorCode = $page?.status ?? '500';
</script>

<div class="h-screen relative absolute">
	<div class="absolute h-full w-full text-center grid content-center">
		<h1 class="text-2xl font-semibold mb-4">Error {errorCode}: {errorMessage}</h1>
		<div class="pt-10 flex items-center justify-center">
			<img class="rounded-md" src="https://http.cat/{errorCode}" alt={errorMessage} />
		</div>
	</div>
</div>
