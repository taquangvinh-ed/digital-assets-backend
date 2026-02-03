package com.example.digital_assets.modules.auth.dto;

import lombok.*;

@Getter
@Setter
@Builder
@NoArgsConstructor
@AllArgsConstructor
public class OtpResponse {

    private boolean success;

    private String message;

    private int retryCount;

}
