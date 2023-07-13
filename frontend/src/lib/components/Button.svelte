<script>
	let className = ''
	export { className as class }
</script>

<div class="{className} flex items-center gap-x-4 bg-white px-4 py-3 rounded-md hover:bg-gray-100 hover:scale-105 transition-all cursor-pointer">
	<slot></slot>
</div>
