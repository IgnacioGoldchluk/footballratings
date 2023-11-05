export default Checkout = {

  async mounted() {
    // Listen for the main events
    document.addEventListener("checkout:pay", e => {
      this.pushEvent("pay", e.detail.payload)
    });
    document.addEventListener("checkout:ready", e => {
      this.pushEvent("checkout-ready")
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
            hidePaymentButton: true,
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
          onSubmit: (cardFormData) => { },
          onError: (error) => { },
        },
      };
      window.cardPaymentBrickController = await bricksBuilder.create('cardPayment', 'cardPaymentBrick_container', settings);
    };
    renderCardPaymentBrick(bricksBuilder);

    const createPayment = async () => {
      const payload = await window.cardPaymentBrickController.getFormData();
      console.log(payload);
      const e = new CustomEvent("checkout:pay", {
        detail: { payload }
      });
      document.dispatchEvent(e);
    };
    window.createPayment = createPayment;
  },
  destroyed() {
    window.cardPaymentBrickController.unmount();
  }
};