defmodule FootballratingsWeb.BillingLive.Checkout do
  use FootballratingsWeb, :live_view

  alias Footballratings.Billing
  alias Footballratings.MercadoPago

  @impl true
  def render(assigns) do
    ~H"""
    <html>
      <head>
        <script src="https://sdk.mercadopago.com/js/v2">
        </script>
      </head>
      <body>
        <div class="text-xl">
          Subscribe for
          <FootballratingsWeb.PlanComponents.plan_billing
            currency={@plan.currency}
            amount={@plan.amount}
            frequency={@plan.frequency}
            frequency_type={@plan.frequency_type}
          />
        </div>
        <div id="cardPaymentBrick_container"></div>
        <.button class="btn btn-primary text-white" id="payment-button">Pagar</.button>
        <script>
          const mp = new MercadoPago('<%= @public_key %>', {
            locale: 'es-AR'
          });
          const bricksBuilder = mp.bricks();
          const renderCardPaymentBrick = async (bricksBuilder) => {
            const settings = {
              initialization: {
                amount: <%= @plan.amount %>,
                payer: {
                  email: '',
                },
              },
              customization: {
                visual: {
                  hidePaymentButton: true,
                  style: {
                    customVariables: {
                      theme: 'default',
                    }
                  }
                },
                  paymentMethods: {
                    maxInstallments: 1,
                  }
              },
              callbacks: {
                onReady: () => {
                  // callback llamado cuando Brick esté listo
                },
                onSubmit: (cardFormData) => {
                  //  callback llamado cuando el usuario haga clic en el botón enviar los datos
                  //  ejemplo de envío de los datos recolectados por el Brick a su servidor

                  cardFormData['preapproval_plan_id'] = '<%= @plan.external_id %>';
                  cardFormData['current_user_email'] = '<%= @current_users.email %>';
                  return new Promise((resolve, reject) => {
                    fetch("/api/process_payment", {
                      method: "POST",
                      headers: {
                        "Content-Type": "application/json",
                      },
                      body: JSON.stringify(cardFormData)
                    })
                      .then((response) => {
                        // recibir el resultado del pago
                        resolve();
                      })
                      .catch((error) => {
                        // tratar respuesta de error al intentar crear el pago
                        reject();
                      })
                  });
                },
                onError: (error) => {
                  // callback llamado para todos los casos de error de Brick
                },
              },
            };
            window.cardPaymentBrickController = await bricksBuilder.create('cardPayment', 'cardPaymentBrick_container', settings);
          };
          renderCardPaymentBrick(bricksBuilder);
        </script>
      </body>
    </html>
    """
  end

  @impl true
  def mount(_params, _session, socket) do
    socket =
      socket
      |> assign(:plan, Billing.latest_active_plan())
      |> assign(:public_key, MercadoPago.Client.public_key())

    {:ok, socket}
  end
end
