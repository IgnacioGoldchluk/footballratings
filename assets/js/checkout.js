export default Checkout = {

  async mounted() {
    // Listen for the main events
    document.addEventListener("checkout:pay", e => {
      this.pushEvent("pay", e.detail.payload)
    });

    const publicKey = document.getElementById("public-key").textContent;
    const planAmount = parseInt(document.getElementById("plan-amount").textContent);

    const mp = new MercadoPago(publicKey, {
      locale: 'es-AR'
    });
    const bricksBuilder = mp.bricks();
    const renderCardPaymentBrick = async (bricksBuilder) => {
      const settings = {
        initialization: {
          amount: planAmount,
          payer: {
            email: '',
          },
        },
        customization: {
          visual: {
            style: {
              customVariables: {
                theme: 'default', // | 'dark' | 'bootstrap' | 'flat'
              }
            }
          },
          paymentMethods: {
            maxInstallments: 1,
          }
        },
        callbacks: {
          onReady: () => { },
          onSubmit: (cardFormData) => {
            const e = new CustomEvent("checkout:pay", {
              detail: { payload: cardFormData }
            });
            document.dispatchEvent(e);
          },
          onError: (error) => { },
        },
      };
      window.cardPaymentBrickController = await bricksBuilder.create('cardPayment', 'cardPaymentBrick_container', settings);
    };
    renderCardPaymentBrick(bricksBuilder);
  },
  destroyed() {
    window.cardPaymentBrickController.unmount();
  }
};