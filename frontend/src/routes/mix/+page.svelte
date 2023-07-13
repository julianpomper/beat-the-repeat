<script lang='ts'>
	import Button from '$lib/components/Button.svelte';
</script>

<svelte:head>
	<title>Home</title>
	<meta name='description' content='Manage your BTR playlist' />
</svelte:head>

<div class='max-w-md relative flex flex-col items-start justify-center gap-y-6'>
	<h2 class='text-4xl font-bold text-white leading-6'>
		Beat the Mix!
	</h2>
	<audio autoplay controls src='https://stream3.radiodienst.de/proxy/fantasy/fantasy'></audio>
	<Button>
		<a href="/home" class='text-sm font-bold text-gray-900 shadow-sm'>
			Go home
		</a>
	</Button>
</div>
