import "@typespec/http";
import "./models.tsp";

using Http;
using Versioning;

@versioned(Versions)
namespace PetStore;

model PetListResponse {
  ...OkResponse;
  ...Body<Pet[]>;
}

model PetResponse {
  ...OkResponse;
  ...Body<Pet>;
}

model PetCreatedResponse {
  ...CreatedResponse;
  ...Body<Pet>;
}

model PetErrorResponse {
  ...BadRequestResponse;
  ...Body<ValidationError>;
}

model PetNotFoundResponse {
  ...NotFoundResponse;
  ...Body<NotFoundError>;
}

model PetUnauthorizedResponse {
  ...UnauthorizedResponse;
  ...Body<UnauthorizedError>;
}

model PetSuccessResponse {
  ...OkResponse;
  ...Body<Pet>;
}

model PetNoContentResponse {
  ...NoContentResponse;
}

model InternalServerErrorResponse {
  @statusCode statusCode: 500;
  ...Body<InternalServerError>;
}
