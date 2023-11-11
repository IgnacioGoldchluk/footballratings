export default Checkout = {
  mounted() {
    LemonSqueezy.Setup({
      eventHandler: (event) => {
        this.pushEvent("checkout-event", event)
      }
    })
  }
}